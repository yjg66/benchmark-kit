-- stats:
-- group by i_category_id: 11 groups, [5316, 212113] tuples per group

SELECT 'store' channel,
               i_category_id ,
               avg(ss_quantity*ss_list_price) sales,
               count(*) number_sales
FROM store_sales , item , date_dim ,
  (SELECT d_week_seq AS week_seq
   FROM date_dim
   WHERE d_year = 2000 + 1
     AND d_moy = 12
     AND d_dom = 24) selected_week
WHERE ss_item_sk = i_item_sk
  AND ss_sold_date_sk = d_date_sk
  AND d_week_seq = week_seq
GROUP BY i_category_id HAVING avg(ss_quantity*ss_list_price) >
  (SELECT avg(quantity*list_price) average_sales
   FROM
     (SELECT ss_quantity quantity ,
             ss_list_price list_price
      FROM store_sales ,
           date_dim
      WHERE ss_sold_date_sk = d_date_sk
        AND d_year BETWEEN 2000 AND 2000 + 2) x)