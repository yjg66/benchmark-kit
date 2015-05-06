-- usage:
-- partition catalog_returns by cr_returning_customer_sk and cache it

-- stats:
-- 85085 tuples in state IL

 WITH customer_total_return AS
  (SELECT cr_returning_customer_sk AS ctr_customer_sk ,
          sum(cr_return_amt_inc_tax) AS ctr_total_return
   FROM catalog_returns , date_dim ,
   WHERE cr_returned_date_sk = d_date_sk
     AND d_year = 1999
   GROUP BY cr_returning_customer_sk)

SELECT c_customer_id,
       c_salutation,
       c_first_name,
       c_last_name,
       ca_street_number,
       ca_street_name ,
       ca_street_type,
       ca_suite_number,
       ca_city,
       ca_county,
       ca_state,
       ca_zip,
       ca_country,
       ca_gmt_offset ,
       ca_location_type,
       ctr_total_return
FROM customer_total_return ctr1 ,
     customer_address ,
     customer ,
  (SELECT 'IL' AS ctr_state,
          avg(ctr_total_return)*1.2 AS avg_return
   FROM customer_total_return ctr2 ,
                              customer_address
   WHERE ca_address_sk = cr_returning_addr_sk
     AND ca_state = 'IL') AS per_state
WHERE ctr1.ctr_total_return > per_state.avg_return
  AND per_state.ctr_state = ca_state
  AND ca_address_sk = c_current_addr_sk
  AND ctr1.ctr_customer_sk = c_customer_sk