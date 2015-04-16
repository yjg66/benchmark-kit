-- group by sr_store_sk, 202 groups, [26670, 100695] tuples per group

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
            sr_store_sk) ctr1 ,
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
   GROUP BY ctr_store_sk) avgtbl ,
                          store ,
                          customer
WHERE ctr1.ctr_store_sk = avgtbl.ctr_store_sk
  AND ctr1.ctr_total_return > avgtbl.ctr_avg
  AND s_store_sk = ctr1.ctr_store_sk
  AND s_state = 'TN'
  AND ctr1.ctr_customer_sk = c_customer_sk