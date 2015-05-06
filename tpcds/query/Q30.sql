-- usage:
-- partition web_returns by sr_customer_sk and cache it, 
-- so that store_returns is sampled by sr_customer_sk

-- stats:
-- group by ctr_state: 7 groups, [18950, 64063] tuples per group

SELECT c_customer_id,
       ctr_total_return
FROM
  (SELECT wr_returning_customer_sk AS ctr_customer_sk ,
          ca_state AS ctr_state,
          sum(wr_return_amt) AS ctr_total_return
   FROM web_returns ,
        date_dim ,
        customer_address
   WHERE wr_returned_date_sk = d_date_sk
     AND d_year = 2000
     AND wr_returning_addr_sk = ca_address_sk
     AND ca_state IN ('SC',
                      'SD',
                      'FL',
                      'CA',
                      'MN',
                      'MO',
                      'GA')
   GROUP BY wr_returning_customer_sk ,
            ca_state) per_ctr , customer_address , customer,
  (SELECT ctr_state,
          avg(ctr_total_return)*1.2 ctr_avg
   FROM
     (SELECT wr_returning_customer_sk AS ctr_customer_sk ,
             ca_state AS ctr_state,
             sum(wr_return_amt) AS ctr_total_return
      FROM web_returns ,
           date_dim ,
           customer_address
      WHERE wr_returned_date_sk = d_date_sk
        AND d_year = 2000
        AND wr_returning_addr_sk = ca_address_sk
        AND ca_state IN ('SC',
                         'SD',
                         'FL',
                         'CA',
                         'MN',
                         'MO',
                         'GA')
      GROUP BY wr_returning_customer_sk ,
               ca_state) ctr2
   GROUP BY ctr_state) per_state
WHERE per_ctr.ctr_total_return > per_state.ctr_avg
  AND per_ctr.ctr_state = per_state.ctr_state
  AND ca_address_sk = c_current_addr_sk
  AND ca_state = 'GA'
  AND per_ctr.ctr_customer_sk = c_customer_sk