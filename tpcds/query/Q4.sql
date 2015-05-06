-- Find the household demographics of which the customers spent more money via catalog than store/web.

-- usage:
-- pre-partition customer by c_current_hdemo_sk and cache it

-- stats:
-- group by current_hdemo: 14402 groups, 
--  [5237, 1873047] tuples per group for store_sales
--  [2815, 998261] tuples per group for catalog_sales
--  [1197, 504202] tuples per group for web_sales

SELECT t_s_secyear.c_current_hdemo_sk
FROM
  (SELECT c_current_hdemo_sk ,
          d_year dyear ,
          sum(((ss_ext_list_price-ss_ext_wholesale_cost-ss_ext_discount_amt)+ss_ext_sales_price)/2) year_total
   FROM customer ,
        store_sales ,
        date_dim
   WHERE c_customer_sk = ss_customer_sk
     AND ss_sold_date_sk = d_date_sk
     AND d_year = 1999
   GROUP BY c_current_hdemo_sk ,
            d_year HAVING year_total > 0) t_s_firstyear ,
  (SELECT c_current_hdemo_sk ,
          d_year dyear ,
          sum(((ss_ext_list_price-ss_ext_wholesale_cost-ss_ext_discount_amt)+ss_ext_sales_price)/2) year_total
   FROM customer ,
        store_sales ,
        date_dim
   WHERE c_customer_sk = ss_customer_sk
     AND ss_sold_date_sk = d_date_sk
     AND d_year = 2000
   GROUP BY c_current_hdemo_sk ,
            d_year) t_s_secyear ,
  (SELECT c_current_hdemo_sk ,
          d_year dyear ,
          sum((((cs_ext_list_price-cs_ext_wholesale_cost-cs_ext_discount_amt)+cs_ext_sales_price)/2)) year_total
   FROM customer ,
        catalog_sales ,
        date_dim
   WHERE c_customer_sk = cs_bill_customer_sk
     AND cs_sold_date_sk = d_date_sk
     AND d_year = 1999
   GROUP BY c_current_hdemo_sk ,
            d_year HAVING year_total > 0) t_c_firstyear ,
  (SELECT c_current_hdemo_sk ,
          d_year dyear ,
          sum((((cs_ext_list_price-cs_ext_wholesale_cost-cs_ext_discount_amt)+cs_ext_sales_price)/2)) year_total
   FROM customer ,
        catalog_sales ,
        date_dim
   WHERE c_customer_sk = cs_bill_customer_sk
     AND cs_sold_date_sk = d_date_sk
     AND d_year = 2000
   GROUP BY c_current_hdemo_sk ,
            d_year) t_c_secyear ,
  (SELECT c_current_hdemo_sk ,
          d_year dyear ,
          sum((((ws_ext_list_price-ws_ext_wholesale_cost-ws_ext_discount_amt)+ws_ext_sales_price)/2)) year_total
   FROM customer ,
        web_sales ,
        date_dim
   WHERE c_customer_sk = ws_bill_customer_sk
     AND ws_sold_date_sk = d_date_sk
     AND d_year = 1999
   GROUP BY c_current_hdemo_sk ,
            d_year HAVING year_total > 0) t_w_firstyear ,
  (SELECT c_current_hdemo_sk ,
          d_year dyear ,
          sum((((ws_ext_list_price-ws_ext_wholesale_cost-ws_ext_discount_amt)+ws_ext_sales_price)/2)) year_total
   FROM customer ,
        web_sales ,
        date_dim
   WHERE c_customer_sk = ws_bill_customer_sk
     AND ws_sold_date_sk = d_date_sk
     AND d_year = 2000
   GROUP BY c_current_hdemo_sk ,
            d_year) t_w_secyear
WHERE t_s_secyear.c_current_hdemo_sk = t_s_firstyear.c_current_hdemo_sk
  AND t_s_firstyear.c_current_hdemo_sk = t_c_secyear.c_current_hdemo_sk
  AND t_s_firstyear.c_current_hdemo_sk = t_c_firstyear.c_current_hdemo_sk
  AND t_s_firstyear.c_current_hdemo_sk = t_w_firstyear.c_current_hdemo_sk
  AND t_s_firstyear.c_current_hdemo_sk = t_w_secyear.c_current_hdemo_sk
  AND t_c_secyear.year_total / t_c_firstyear.year_total > t_s_secyear.year_total / t_s_firstyear.year_total
  AND t_c_secyear.year_total / t_c_firstyear.year_total > t_w_secyear.year_total / t_w_firstyear.year_total