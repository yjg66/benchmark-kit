-- usage:
-- partition web_returns join customer_address by sr_customer_sk and cache it, 
-- so that store_returns is sampled by sr_customer_sk

-- stats:
-- group by ctr_state: 49 groups, [4213, 102700] tuples per group

WITH customer_total_return AS
  (SELECT wr_returning_customer_sk AS ctr_customer_sk ,
          ca_state AS ctr_state ,
          sum(wr_return_amt) AS ctr_total_return
   FROM web_returns ,
        date_dim ,
        customer_address
   WHERE wr_returned_date_sk = d_date_sk
     AND d_year = 2000
     AND wr_returning_addr_sk = ca_address_sk
     AND ca_state NOT IN ('DC', 'HI', 'DE')
   GROUP BY wr_returning_customer_sk ,
            ca_state) 
SELECT c_customer_id,
       ctr_total_return
FROM customer_total_return , customer_address , customer ,
  (SELECT ctr_state,
          avg(ctr_total_return)*1.2 ctr_avg
   FROM customer_total_return
   GROUP BY ctr_state) per_state
WHERE customer_total_return.ctr_total_return > per_state.ctr_avg
  AND customer_total_return.ctr_state = per_state.ctr_state
  AND ca_address_sk = c_current_addr_sk
  AND ca_state = 'GA'
  AND customer_total_return.ctr_customer_sk = c_customer_sk

-- define STATE= dist(fips_county, 3, 1);
-- define YEAR= random(1999, 2002, uniform);
-- define _LIMIT=100;
-- 
-- with customer_total_return as
-- (select wr_returning_customer_sk as ctr_customer_sk
--        ,ca_state as ctr_state, 
--  sum(wr_return_amt) as ctr_total_return
-- from web_returns
--     ,date_dim
--     ,customer_address
-- where wr_returned_date_sk = d_date_sk 
--   and d_year =[YEAR]
--   and wr_returning_addr_sk = ca_address_sk 
-- group by wr_returning_customer_sk
--         ,ca_state)
-- [_LIMITA] select [_LIMITB] c_customer_id,c_salutation,c_first_name,c_last_name,c_preferred_cust_flag
--       ,c_birth_day,c_birth_month,c_birth_year,c_birth_country,c_login,c_email_address
--       ,c_last_review_date,ctr_total_return
-- from customer_total_return ctr1
--     ,customer_address
--     ,customer
-- where ctr1.ctr_total_return > (select avg(ctr_total_return)*1.2
--        from customer_total_return ctr2 
--                      where ctr1.ctr_state = ctr2.ctr_state)
--       and ca_address_sk = c_current_addr_sk
--       and ca_state = '[STATE]'
--       and ctr1.ctr_customer_sk = c_customer_sk
-- order by c_customer_id,c_salutation,c_first_name,c_last_name,c_preferred_cust_flag
--                  ,c_birth_day,c_birth_month,c_birth_year,c_birth_country,c_login,c_email_address
--                  ,c_last_review_date,ctr_total_return
-- [_LIMITC];