-- stats:
-- group by i_class_id: 17 groups, [5522, 348192] tuples per group

SELECT sum(ws_ext_discount_amt) AS "Excess Discount Amount"
FROM web_sales ,item ,date_dim,
  (SELECT i_class_id AS class_id,
          1.3 * avg(ws_ext_discount_amt) AS avg_sales
   FROM web_sales ,
        date_dim ,
        item
   WHERE i_item_sk = ws_item_sk
     AND d_date BETWEEN '2000-01-01' AND '2000-04-01'
     AND d_date_sk = ws_sold_date_sk
   GROUP BY i_class_id) avg_sales
WHERE i_manufact_id = 200
  AND i_item_sk = ws_item_sk
  AND d_date BETWEEN '2000-01-01' AND '2000-04-01'
  AND d_date_sk = ws_sold_date_sk
  AND i_class_id = avg_sales.class_id
  AND ws_ext_discount_amt > avg_sales.avg_sales