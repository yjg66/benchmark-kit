-- stats:
-- group by ss_store_sk: 183 groups, [178775, 186595] tuples per group

SELECT ss_store_sk ,
       cnt
FROM
  (SELECT ss_store_sk ,
          count(*) cnt
   FROM store_sales, date_dim, store
   WHERE store_sales.ss_sold_date_sk = date_dim.d_date_sk
     AND store_sales.ss_store_sk = store.s_store_sk
     AND (date_dim.d_dom BETWEEN 1 AND 3
          OR date_dim.d_dom BETWEEN 25 AND 28)
     AND date_dim.d_year IN (1998,
                             1998+1,
                             1998+2)
     AND store.s_county IN ('Ziebach County',
                            'Daviess County',
                            'Richland County',
                            'Walker County',
                            'Williamson County',
                            'Luce County',
                            'Fairfield County',
                            'Franklin Parish')
   GROUP BY ss_store_sk) dn
WHERE cnt BETWEEN 179000 AND 182000

-- define BPONE= text({"1001-5000",1},{">10000",1},{"501-1000",1});
-- define BPTWO= text({"0-500",1},{"unknown",1},{"5001-10000",1});
-- define YEAR= random(1998, 2000, uniform);
-- define COUNTYNUMBER=ulist(random(1, rowcount("active_counties", "store"), uniform), 8);
-- define COUNTY_A=distmember(fips_county, [COUNTYNUMBER.1], 2);
-- define COUNTY_B=distmember(fips_county, [COUNTYNUMBER.2], 2);
-- define COUNTY_C=distmember(fips_county, [COUNTYNUMBER.3], 2);
-- define COUNTY_D=distmember(fips_county, [COUNTYNUMBER.4], 2);
-- define COUNTY_E=distmember(fips_county, [COUNTYNUMBER.5], 2);
-- define COUNTY_F=distmember(fips_county, [COUNTYNUMBER.6], 2);
-- define COUNTY_G=distmember(fips_county, [COUNTYNUMBER.7], 2);
-- define COUNTY_H=distmember(fips_county, [COUNTYNUMBER.8], 2);
-- 
-- 
-- select c_last_name
--       ,c_first_name
--       ,c_salutation
--       ,c_preferred_cust_flag
--       ,ss_ticket_number
--       ,cnt from
--   (select ss_ticket_number
--          ,ss_customer_sk
--          ,count(*) cnt
--    from store_sales,date_dim,store,household_demographics
--    where store_sales.ss_sold_date_sk = date_dim.d_date_sk
--    and store_sales.ss_store_sk = store.s_store_sk  
--    and store_sales.ss_hdemo_sk = household_demographics.hd_demo_sk
--    and (date_dim.d_dom between 1 and 3 or date_dim.d_dom between 25 and 28)
--    and (household_demographics.hd_buy_potential = '[BPONE]' or
--         household_demographics.hd_buy_potential = '[BPTWO]')
--    and household_demographics.hd_vehicle_count > 0
--    and (case when household_demographics.hd_vehicle_count > 0 
--  then household_demographics.hd_dep_count/ household_demographics.hd_vehicle_count 
--  else null 
--  end)  > 1.2
--    and date_dim.d_year in ([YEAR],[YEAR]+1,[YEAR]+2)
--    and store.s_county in ('[COUNTY_A]','[COUNTY_B]','[COUNTY_C]','[COUNTY_D]',
--                           '[COUNTY_E]','[COUNTY_F]','[COUNTY_G]','[COUNTY_H]')
--    group by ss_ticket_number,ss_customer_sk) dn,customer
--    where ss_customer_sk = c_customer_sk
--      and cnt between 15 and 20
--    order by c_last_name,c_first_name,c_salutation,c_preferred_cust_flag desc;--