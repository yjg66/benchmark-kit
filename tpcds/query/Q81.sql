-- usage:
-- partition catalog_returns by cr_returning_customer_sk and cache it
-- register customer_total_return as a table, only keeping the rdd and schema, but not the plan

-- stats:
-- group by state: 51 groups, [2526, 209010] tuples per group

 WITH customer_total_return AS
  (SELECT cr_returning_customer_sk AS ctr_customer_sk ,
          ca_state AS ctr_state ,
          sum(cr_return_amt_inc_tax) AS ctr_total_return
   FROM catalog_returns , date_dim , customer_address
   WHERE cr_returned_date_sk = d_date_sk
     AND d_year = 1999
     AND cr_returning_addr_sk = ca_address_sk
     AND ca_state NOT IN ('DC')
   GROUP BY cr_returning_customer_sk ,
            ca_state)
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
    (SELECT ctr_state,
            avg(ctr_total_return)*1.2 AS avg_return
     FROM customer_total_return ctr2
     GROUP BY ctr_state) AS per_state
WHERE ctr1.ctr_total_return > per_state.avg_return
  AND per_state.ctr_state = ctr1.ctr_state
  AND ca_state = 'IL'
  AND ca_address_sk = c_current_addr_sk
  AND ctr1.ctr_customer_sk = c_customer_sk

-- define STATE= dist(fips_county, 3, 1);
-- define YEAR= random(1998, 2002, uniform);
-- define _LIMIT=100; 
-- 
-- with customer_total_return as
-- (select cr_returning_customer_sk as ctr_customer_sk
--        ,ca_state as ctr_state, 
--  sum(cr_return_amt_inc_tax) as ctr_total_return
-- from catalog_returns
--     ,date_dim
--     ,customer_address
-- where cr_returned_date_sk = d_date_sk 
--   and d_year =[YEAR]
--   and cr_returning_addr_sk = ca_address_sk 
-- group by cr_returning_customer_sk
--         ,ca_state )
-- [_LIMITA] select [_LIMITB] c_customer_id,c_salutation,c_first_name,c_last_name,ca_street_number,ca_street_name
--                   ,ca_street_type,ca_suite_number,ca_city,ca_county,ca_state,ca_zip,ca_country,ca_gmt_offset
--                  ,ca_location_type,ctr_total_return
-- from customer_total_return ctr1
--     ,customer_address
--     ,customer
-- where ctr1.ctr_total_return > (select avg(ctr_total_return)*1.2
--        from customer_total_return ctr2 
--                      where ctr1.ctr_state = ctr2.ctr_state)
--       and ca_address_sk = c_current_addr_sk
--       and ca_state = '[STATE]'
--       and ctr1.ctr_customer_sk = c_customer_sk
-- order by c_customer_id,c_salutation,c_first_name,c_last_name,ca_street_number,ca_street_name
--                   ,ca_street_type,ca_suite_number,ca_city,ca_county,ca_state,ca_zip,ca_country,ca_gmt_offset
--                  ,ca_location_type,ctr_total_return
-- [_LIMITC];