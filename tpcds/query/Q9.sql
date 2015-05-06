-- stats:
-- group by ss_quantity / 20: 6 groups (one group is null), [55001009, 55023274] tuples per group
-- rowcount("store_sales")/5 = 57599404.8

SELECT IF (number_sales > 55006000,
           avg_ext_tax,
           avg_inc_tax)
FROM
  (SELECT count(*) AS number_sales ,
          avg(ss_ext_tax) AS avg_ext_tax,
          avg(ss_net_paid_inc_tax) AS avg_inc_tax
   FROM store_sales
   GROUP BY cast((ss_quantity - 1) / 20 AS int)) histogram