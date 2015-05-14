-- usage:
-- partition store_sales by ss_item_sk and cache it, 
-- so that store_sales is sampled by ss_item_sk
-- register item_total_sales as a table, only keeping the rdd and schema, but not the plan

-- stats:
-- group by d_qoy: 4 groups, [3618, 6871] tuples per group

WITH item_total_sales
  (SELECT i_item_sk , d_qoy , sum(ss_sales_price) sum_sales
   FROM item , store_sales , date_dim , store
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
   GROUP BY i_item_sk , d_qoy)
SELECT count(1)
FROM item_total_sales ,
    (SELECT d_qoy ,
            avg(sum_sales) AS avg_quarterly_sales
     FROM item_total_sales
     GROUP BY d_qoy) quaterly
WHERE item_total_sales.d_qoy = quaterly.d_qoy
  AND CASE
          WHEN avg_quarterly_sales > 0 THEN abs(sum_sales - avg_quarterly_sales)/avg_quarterly_sales
          ELSE NULL
      END > 0.1

-- define DMS = random(1176,1224,uniform);
-- define _LIMIT=100;
-- 
-- [_LIMITA] select [_LIMITB] * from 
-- (select i_manufact_id,
-- sum(ss_sales_price) sum_sales,
-- avg(sum(ss_sales_price)) over (partition by i_manufact_id) avg_quarterly_sales
-- from item, store_sales, date_dim, store
-- where ss_item_sk = i_item_sk and
-- ss_sold_date_sk = d_date_sk and
-- ss_store_sk = s_store_sk and
-- d_month_seq in ([DMS],[DMS]+1,[DMS]+2,[DMS]+3,[DMS]+4,[DMS]+5,[DMS]+6,[DMS]+7,[DMS]+8,[DMS]+9,[DMS]+10,[DMS]+11) and
-- ((i_category in ('Books','Children','Electronics') and
-- i_class in ('personal','portable','reference','self-help') and
-- i_brand in ('scholaramalgamalg #14','scholaramalgamalg #7',
--     'exportiunivamalg #9','scholaramalgamalg #9'))
-- or(i_category in ('Women','Music','Men') and
-- i_class in ('accessories','classical','fragrances','pants') and
-- i_brand in ('amalgimporto #1','edu packscholar #1','exportiimporto #1',
--     'importoamalg #1')))
-- group by i_manufact_id, d_qoy ) tmp1
-- where case when avg_quarterly_sales > 0 
--   then abs (sum_sales - avg_quarterly_sales)/ avg_quarterly_sales 
--   else null end > 0.1
-- order by avg_quarterly_sales,
--    sum_sales,
--    i_manufact_id
-- [_LIMITC];