-- stats:
-- group by s_store_name: 8 groups, [41789, 193421] tuples per group

SELECT s_store_name,
       paid
FROM
  (SELECT 0 AS KEY,
          s_store_name ,
          sum(ss_net_paid) paid
   FROM store_sales ,
        store ,
        item ,
        customer ,
        customer_address
   WHERE ss_customer_sk = c_customer_sk
     AND ss_item_sk = i_item_sk
     AND ss_store_sk = s_store_sk
     AND c_birth_country = upper(ca_country)
     AND s_zip = ca_zip
     AND s_market_id = 8
     AND i_color = 'orange'
   GROUP BY s_store_name) t1,
  (SELECT 0 AS KEY,
          0.05*avg(paid) AS avg_paid
   FROM
     (SELECT s_store_name ,
             sum(ss_net_paid) paid
      FROM store_sales ,
           store ,
           item ,
           customer ,
           customer_address
      WHERE ss_customer_sk = c_customer_sk
        AND ss_item_sk = i_item_sk
        AND ss_store_sk = s_store_sk
        AND c_birth_country = upper(ca_country)
        AND s_zip = ca_zip
        AND s_market_id = 8
      GROUP BY s_store_name) t) t2
WHERE t1.KEY = t2.KEY
  AND t1.paid > t2.avg_paid