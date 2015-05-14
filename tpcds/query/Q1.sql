-- usage:
-- partition store_returns by sr_customer_sk and cache it, 
-- so that store_returns is sampled by sr_customer_sk
-- register customer_total_return as a table, only keeping the rdd and schema, but not the plan

-- stats:
-- group by sr_store_sk: 202 groups, [26670, 100695] tuples per group
-- return 139060 c_customer_id

WITH customer_total_return AS
  (SELECT sr_customer_sk AS ctr_customer_sk ,
          sr_store_sk AS ctr_store_sk ,
          sum(SR_REVERSED_CHARGE) AS ctr_total_return
   FROM store_returns ,
        date_dim
   WHERE sr_returned_date_sk = d_date_sk
     AND d_year = 2001
   GROUP BY sr_customer_sk ,
            sr_store_sk)
SELECT count(c_customer_id)
FROM customer_total_return , store , customer ,
  (SELECT ctr_store_sk,
          avg(ctr_total_return)*1.2 ctr_avg
   FROM customer_total_return
   GROUP BY ctr_store_sk) store_average_return
WHERE customer_total_return.ctr_store_sk = store_average_return.ctr_store_sk
  AND customer_total_return.ctr_total_return > store_average_return.ctr_avg
  AND s_store_sk = customer_total_return.ctr_store_sk
  AND s_state = 'TN'
  AND customer_total_return.ctr_customer_sk = c_customer_sk

-- define COUNTY = random(1, rowcount("active_counties", "store"), uniform);
-- define STATE = distmember(fips_county, [COUNTY], 3); 
-- define YEAR = random(1998, 2002, uniform);
-- define AGG_FIELD = text({"SR_RETURN_AMT",1},{"SR_FEE",1},{"SR_REFUNDED_CASH",1},{"SR_RETURN_AMT_INC_TAX",1},{"SR_REVERSED_CHARGE",1},{"SR_STORE_CREDIT",1},{"SR_RETURN_TAX",1});
-- define _LIMIT=100;
-- 
-- with customer_total_return as
-- (select sr_customer_sk as ctr_customer_sk
-- ,sr_store_sk as ctr_store_sk
-- ,sum([AGG_FIELD]) as ctr_total_return
-- from store_returns
-- ,date_dim
-- where sr_returned_date_sk = d_date_sk
-- and d_year =[YEAR]
-- group by sr_customer_sk
-- ,sr_store_sk)
-- [_LIMITA] select [_LIMITB] c_customer_id
-- from customer_total_return ctr1
-- ,store
-- ,customer
-- where ctr1.ctr_total_return > (select avg(ctr_total_return)*1.2
-- from customer_total_return ctr2
-- where ctr1.ctr_store_sk = ctr2.ctr_store_sk)
-- and s_store_sk = ctr1.ctr_store_sk
-- and s_state = '[STATE]'
-- and ctr1.ctr_customer_sk = c_customer_sk
-- order by c_customer_id
-- [_LIMITC];