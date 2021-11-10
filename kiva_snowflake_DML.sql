#populate dim_world_region#
insert into kiva_snowflake.dim_world_region (world_region_id,world_region_name)
(select world_region_id, world_region_name from KIVA.world_region);

#populate dim_country#
insert into kiva_snowflake.dim_country
(country_id,country_code,country_name,currency,
population_in_thousands,gdp,gdp_growth_rate,population_below_poverty_line,hdi,life_expectancy
,gni
,country_mpi
,world_region_key)
select country_id,country_code,country_name,currency,population_in_thousands, gdp,gdp_growth_rate,population_below_poverty_line,hdi,life_expectancy
,gni
,country_mpi, world_region_key
from KIVA.country as c 
left join KIVA.world_region w 
on c.world_region_id = w.world_region_id
left join kiva_snowflake.dim_world_region wd
on wd.world_region_id = w.world_region_id;


#populate dim_region#
insert into kiva_snowflake.dim_region (region_id,region_name,region_mpi,country_key)
select region_id, region_name, region_mpi, country_key 
from KIVA.region r
left join KIVA.country c
on c.country_id = r.country_id
left join dim_country cd
on cd.country_id = c.country_id;

#populate dim_partner#
insert into kiva_snowflake.dim_partner (partner_id, partner_name)
(select partner_id, partner_name from KIVA.partner);

#populate dim_borrower#
insert into kiva_snowflake.dim_borrower ( borrower_id, gender, region_key)
select b.borrower_id, b.gender, region_key
from KIVA.borrower b
left join KIVA.region r on
b.region_id = r.region_id
left join dim_region rd
on rd.region_id = r.region_id;

#populate dim_category#
insert into kiva_snowflake.dim_category (category_id, category_name, sector_name)
select c.category_id, c.category_name, s.sector_name
from KIVA.category as c
left join KIVA.sector s
on c.sector_id = s.sector_id;


#populate fact_loan#
insert into kiva_snowflake.fact_loan (loan_id, borrower_key, partner_key, loan_amount, funded_amount, category_key, region_key, country_key, lenders_count, posted_time, disbursed_time,funded_time, repayment_interval,
repayment_terms, loan_theme_type,loan_state,disbursed_state,funded_state)
select l.loan_id,borrower_key, partner_key, loan_amount, funded_amount, category_key, region_key, country_key, lenders_count, posted_time, disbursed_time,funded_time, repayment_interval,
repayment_terms, loan_theme_type ,
(posted_time is not null),
(disbursed_time is not null),
(funded_time is not null)
from KIVA.loan as l
left join KIVA.borrower b
on b.borrower_id = l.borrower_id
on b.borrower_id = l.borrower_id
left join dim_borrower bd
on b.borrower_id = bd.borrower_id
left join dim_partner pd
on l.partner_id = pd.partner_id
left join KIVA.category c
on c.category_id = l.category_id
left join dim_category 
on dim_category.category_id = l.category_id
left join dim_country 
on dim_country.country_id = l.country_id
left join KIVA.loan_theme_profile p
on p.loan_id = l.loan_id
left join KIVA.loan_theme t
on t.loan_theme_id =p.loan_theme_id;

select * from KIVA.loan as l 
left join KIVA.borrower b
on b.borrower_id = l.borrower_id;





