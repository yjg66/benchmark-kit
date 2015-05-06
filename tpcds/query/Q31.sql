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