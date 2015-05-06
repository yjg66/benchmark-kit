-- stats:
-- group by d_year, i_category_id: 55 groups, [23206, 947907] tuples per group

SELECT dt.d_year ,
       item.i_category_id brand_id ,
       sum(ss_net_profit) sum_agg
FROM date_dim dt ,
     store_sales ,
     item
WHERE dt.d_date_sk = store_sales.ss_sold_date_sk
  AND store_sales.ss_item_sk = item.i_item_sk
  AND dt.d_moy=12
GROUP BY dt.d_year ,
         item.i_category_id