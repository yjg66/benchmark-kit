-- stats:
-- 6871 items

WITH per_item
  (SELECT 0 AS KEY, i_item_sk, sum(ss_sales_price) sum_sales
   FROM item, store_sales, date_dim, store
   WHERE ss_item_sk = i_item_sk
     AND ss_sold_date_sk = d_date_sk
     AND ss_store_sk = s_store_sk
     AND d_month_seq IN (1200,1200+1,1200+2,1200+3,1200+4,1200+5,1200+6,1200+7,1200+8,1200+9,1200+10,1200+11)
     AND ((i_category IN ('Books', 'Children', 'Electronics')
           AND i_class IN ('personal', 'portable', 'reference', 'self-help')
           AND i_brand IN ('scholaramalgamalg #14', 'scholaramalgamalg #7', 'exportiunivamalg #9', 'scholaramalgamalg #9'))
          OR (i_category IN ('Women', 'Music', 'Men')
              AND i_class IN ('accessories', 'classical', 'fragrances', 'pants')
              AND i_brand IN ('amalgimporto #1', 'edu packscholar #1', 'exportiimporto #1', 'importoamalg #1')))
   GROUP BY i_item_sk)

SELECT *
FROM per_item ,
  (SELECT 0 AS KEY,
          avg(sum_sales) AS avg_quarterly_sales
   FROM per_item) quaterly
WHERE per_item.KEY = quaterly.KEY
  AND CASE
          WHEN avg_quarterly_sales > 0 THEN abs(sum_sales - avg_quarterly_sales)/avg_quarterly_sales
          ELSE NULL
      END > 0.1