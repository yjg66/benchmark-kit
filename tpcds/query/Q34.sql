-- stats:
-- group by ss_store_sk: 183 groups, [178775, 186595] tuples per group

SELECT ss_store_sk ,
       cnt
FROM
  (SELECT ss_store_sk ,
          count(*) cnt
   FROM store_sales, date_dim, store,
   WHERE store_sales.ss_sold_date_sk = date_dim.d_date_sk
     AND store_sales.ss_store_sk = store.s_store_sk
     AND (date_dim.d_dom BETWEEN 1 AND 3
          OR date_dim.d_dom BETWEEN 25 AND 28)
     AND date_dim.d_year IN (1998,
                             1998+1,
                             1998+2)
     AND store.s_county IN ('Ziebach County',
                            'Daviess County',
                            'Richland County',
                            'Walker County',
                            'Williamson County',
                            'Luce County',
                            'Fairfield County',
                            'Franklin Parish')
   GROUP BY ss_store_sk) dn
WHERE ss_customer_sk = c_customer_sk
  AND cnt BETWEEN 179000 AND 182000