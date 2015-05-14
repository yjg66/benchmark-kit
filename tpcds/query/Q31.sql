-- stats:
-- group by ca_state and qoy: 
--   store: 98 groups, [12231, 650103] tuples per group
--   web: 98 groups, [3280, 171278] tuples per group

SELECT ss1.ca_state ,
       ss1.d_year ,
       ws2.web_sales/ws1.web_sales web_q1_q2_increase ,
       ss2.store_sales/ss1.store_sales store_q1_q2_increase
FROM
  (SELECT ca_state,
          d_qoy,
          d_year,
          sum(ss_ext_sales_price) AS store_sales
   FROM store_sales,
        date_dim,
        customer_address
   WHERE ss_sold_date_sk = d_date_sk
     AND ss_addr_sk=ca_address_sk
     AND NOT (ca_state IN ('DC',
                           'DE',
                           'HI'))
     AND d_year = 1999
     AND d_qoy = 1
   GROUP BY ca_state,
            d_qoy,
            d_year) ss1 ,
  (SELECT ca_state,
          d_qoy,
          d_year,
          sum(ss_ext_sales_price) AS store_sales
   FROM store_sales,
        date_dim,
        customer_address
   WHERE ss_sold_date_sk = d_date_sk
     AND ss_addr_sk=ca_address_sk
     AND NOT (ca_state IN ('DC',
                           'DE',
                           'HI'))
     AND d_year = 1999
     AND d_qoy = 2
   GROUP BY ca_state,
            d_qoy,
            d_year) ss2 ,
  (SELECT ca_state,
          d_qoy,
          d_year,
          sum(ws_ext_sales_price) AS web_sales
   FROM web_sales,
        date_dim,
        customer_address
   WHERE ws_sold_date_sk = d_date_sk
     AND ws_bill_addr_sk=ca_address_sk
     AND NOT (ca_state IN ('DC',
                           'DE',
                           'HI'))
     AND d_year = 1999
     AND d_qoy = 1
   GROUP BY ca_state,
            d_qoy,
            d_year) ws1 ,
  (SELECT ca_state,
          d_qoy,
          d_year,
          sum(ws_ext_sales_price) AS web_sales
   FROM web_sales,
        date_dim,
        customer_address
   WHERE ws_sold_date_sk = d_date_sk
     AND ws_bill_addr_sk=ca_address_sk
     AND NOT (ca_state IN ('DC',
                           'DE',
                           'HI'))
     AND d_year = 1999
     AND d_qoy = 2
   GROUP BY ca_state,
            d_qoy,
            d_year) ws2
WHERE ss1.ca_state = ss2.ca_state
  AND ss1.ca_state = ws1.ca_state
  AND ws1.ca_state = ws2.ca_state
  AND CASE
          WHEN ws1.web_sales > 0 THEN ws2.web_sales/ws1.web_sales
          ELSE NULL
      END > CASE
                WHEN ss1.store_sales > 0 THEN ss2.store_sales/ss1.store_sales
                ELSE NULL
            END

-- define YEAR=random(1998,2002,uniform);
-- define AGG= text({"ss1.ca_county",1},{"ss1.d_year",1},{"web_q1_q2_increase",1},{"store_q1_q2_increase",1},{"web_q2_q3_increase",1},{"store_q2_q3_increase",1}); 
--
--
-- with ss as
-- (select ca_county,d_qoy, d_year,sum(ss_ext_sales_price) as store_sales
-- from store_sales,date_dim,customer_address
-- where ss_sold_date_sk = d_date_sk
--  and ss_addr_sk=ca_address_sk
-- group by ca_county,d_qoy, d_year),
-- ws as
-- (select ca_county,d_qoy, d_year,sum(ws_ext_sales_price) as web_sales
-- from web_sales,date_dim,customer_address
-- where ws_sold_date_sk = d_date_sk
--  and ws_bill_addr_sk=ca_address_sk
-- group by ca_county,d_qoy, d_year)
-- select 
--        ss1.ca_county
--       ,ss1.d_year
--       ,ws2.web_sales/ws1.web_sales web_q1_q2_increase
--       ,ss2.store_sales/ss1.store_sales store_q1_q2_increase
--       ,ws3.web_sales/ws2.web_sales web_q2_q3_increase
--       ,ss3.store_sales/ss2.store_sales store_q2_q3_increase
-- from
--        ss ss1
--       ,ss ss2
--       ,ss ss3
--       ,ws ws1
--       ,ws ws2
--       ,ws ws3
-- where
--    ss1.d_qoy = 1
--    and ss1.d_year = [YEAR]
--    and ss1.ca_county = ss2.ca_county
--    and ss2.d_qoy = 2
--    and ss2.d_year = [YEAR]
-- and ss2.ca_county = ss3.ca_county
--    and ss3.d_qoy = 3
--    and ss3.d_year = [YEAR]
--    and ss1.ca_county = ws1.ca_county
--    and ws1.d_qoy = 1
--    and ws1.d_year = [YEAR]
--    and ws1.ca_county = ws2.ca_county
--    and ws2.d_qoy = 2
--    and ws2.d_year = [YEAR]
--    and ws1.ca_county = ws3.ca_county
--    and ws3.d_qoy = 3
--    and ws3.d_year =[YEAR]
--    and case when ws1.web_sales > 0 then ws2.web_sales/ws1.web_sales else null end 
--       > case when ss1.store_sales > 0 then ss2.store_sales/ss1.store_sales else null end
--    and case when ws2.web_sales > 0 then ws3.web_sales/ws2.web_sales else null end
--       > case when ss2.store_sales > 0 then ss3.store_sales/ss2.store_sales else null end
-- order by [AGG];