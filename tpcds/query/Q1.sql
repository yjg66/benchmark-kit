-- usage:
-- partition store_returns by sr_customer_sk and cache it, 
-- so that store_returns is sampled by sr_customer_sk

-- stats:
-- group by sr_store_sk: 202 groups, [26670, 100695] tuples per group
-- return 139060 c_customer_id

SELECT c_customer_id
FROM
  (SELECT sr_customer_sk AS ctr_customer_sk ,
          sr_store_sk AS ctr_store_sk ,
          sum(SR_REVERSED_CHARGE) AS ctr_total_return
   FROM store_returns ,
        date_dim
   WHERE sr_returned_date_sk = d_date_sk
     AND d_year = 2001
   GROUP BY sr_customer_sk ,
            sr_store_sk) per_ctr ,
  (SELECT ctr_store_sk,
          avg(ctr_total_return)*1.2 ctr_avg
   FROM
     (SELECT sr_customer_sk AS ctr_customer_sk ,
             sr_store_sk AS ctr_store_sk ,
             sum(SR_REVERSED_CHARGE) AS ctr_total_return
      FROM store_returns ,
           date_dim
      WHERE sr_returned_date_sk = d_date_sk
        AND d_year = 2001
      GROUP BY sr_customer_sk ,
               sr_store_sk) ctr2
   GROUP BY ctr_store_sk) per_store ,
                          store ,
                          customer
WHERE per_ctr.ctr_store_sk = per_store.ctr_store_sk
  AND per_ctr.ctr_total_return > per_store.ctr_avg
  AND s_store_sk = per_ctr.ctr_store_sk
  AND s_state = 'TN'
  AND per_ctr.ctr_customer_sk = c_customer_sk