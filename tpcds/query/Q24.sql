-- stats:
-- group by s_store_name: 8 groups, [41789, 193421] tuples per group

SELECT s_store_name,
       paid
FROM
  (SELECT 0 AS key,
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
  (SELECT 0 AS key,
          0.01*avg(paid) AS avg_paid
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
WHERE t1.key = t2.key
  AND t1.paid > t2.avg_paid

-- define MARKET=random(5,10,uniform);
-- define AMOUNTONE=text({"ss_net_paid",1},{"ss_net_paid_inc_tax",1},{"ss_net_profit",1},{"ss_sales_price",1},{"ss_ext_sales_price",1});
-- define COLOR=ulist(dist(colors,1,1),2);
-- 
-- with ssales as
-- (select c_last_name
--       ,c_first_name
--       ,s_store_name
--       ,ca_state
--       ,s_state
--       ,i_color
--       ,i_current_price
--       ,i_manager_id
--       ,i_units
--       ,i_size
--       ,sum([AMOUNTONE]) netpaid
-- from store_sales
--     ,store_returns
--     ,store
--     ,item
--     ,customer
--     ,customer_address
-- where ss_ticket_number = sr_ticket_number
--   and ss_item_sk = sr_item_sk
--   and ss_customer_sk = c_customer_sk
--   and ss_item_sk = i_item_sk
--   and ss_store_sk = s_store_sk
--   and c_birth_country = upper(ca_country)
--   and s_zip = ca_zip
-- and s_market_id=[MARKET]
-- group by c_last_name
--         ,c_first_name
--         ,s_store_name
--         ,ca_state
--         ,s_state
--         ,i_color
--         ,i_current_price
--         ,i_manager_id
--         ,i_units
--         ,i_size)
-- select c_last_name
--       ,c_first_name
--       ,s_store_name
--       ,sum(netpaid) paid
-- from ssales
-- where i_color = '[COLOR.1]'
-- group by c_last_name
--         ,c_first_name
--         ,s_store_name
-- having sum(netpaid) > (select 0.05*avg(netpaid)
--                                  from ssales)
-- ;
-- 
-- with ssales as
-- (select c_last_name
--       ,c_first_name
--       ,s_store_name
--       ,ca_state
--       ,s_state
--       ,i_color
--       ,i_current_price
--       ,i_manager_id
--       ,i_units
--       ,i_size
--       ,sum([AMOUNTONE]) netpaid
-- from store_sales
--     ,store_returns
--     ,store
--     ,item
--     ,customer
--     ,customer_address
-- where ss_ticket_number = sr_ticket_number
--   and ss_item_sk = sr_item_sk
--   and ss_customer_sk = c_customer_sk
--   and ss_item_sk = i_item_sk
--   and ss_store_sk = s_store_sk
--   and c_birth_country = upper(ca_country)
--   and s_zip = ca_zip
--   and s_market_id = [MARKET]
-- group by c_last_name
--         ,c_first_name
--         ,s_store_name
--         ,ca_state
--         ,s_state
--         ,i_color
--         ,i_current_price
--         ,i_manager_id
--         ,i_units
--         ,i_size)
-- select c_last_name
--       ,c_first_name
--       ,s_store_name
--       ,sum(netpaid) paid
-- from ssales
-- where i_color = '[COLOR.2]'
-- group by c_last_name
--         ,c_first_name
--         ,s_store_name
-- having sum(netpaid) > (select 0.05*avg(netpaid)
--                            from ssales)
-- ;