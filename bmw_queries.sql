select * from bmw_2018;

-- Q1 region wise sales.
create view beamerone as select region,sum(units_sold) as total_units from bmw_2018
group by region
order by 2 desc;
select * from beamerone;

-- Q2 total sales in year and compared to previous months sales and difference is meausred in %.
create view beamertwo as with cte as (select 
year,
sum(units_sold) as total_units
from bmw_2018
group by 1)
select *,
total_units-lag(total_units) over (order by year) as prev_diff,
concat(round((total_units-lag(total_units) over (order by year)) * 100/
(lag(total_units) over (order by year)),2),'%') as diff_in_per
from cte;
select * from beamertwo;

-- Q3 3 years moving average.
create view beamerthree as with cte as (select year,
sum(units_sold) as total_sold
from bmw_2018 
group by 1)
select *,
round(avg(total_sold) over (order by year rows between 2 preceding and current row),2) as running_avg
from cte;
select * from beamerthree;

-- Q4 yoy particular model sales and their model progress in percent.(you can write any bmw model here). 
create view beamerfour as with cte as (select year,
model,
sum(units_sold) as total_unit_sold 
from bmw_2018 
where model = '5 series'
group by 1)
select *,
concat(round((total_unit_sold-lag(total_unit_sold) over (order by year)) * 100/
(lag(total_unit_sold) over (order by year)),2),'%') as prog_in_perc
from cte;
select * from beamerfour;


-- Q5 regional yoy growth.
create view beamerfive as with cte as (select year,
region,
sum(units_sold) as total_units
from bmw_2018 
group by 1,2)
select *,
total_units-lag(total_units) over (partition by region order by year) as region_yoy
from cte;

-- Q6 regions total revenue
select region,
sum(revenue_eur) as total_sales 
from bmw_2018
group by 1;

-- Q7 year plus region total revenue 
select year,
region,
sum(revenue_eur) as total_sales
from bmw_2018 
group by 1,2;

-- Q8 average price eur for models 
select model,
round(avg(avg_price_eur),2) as avg_price 
from bmw_2018
group by 1;

-- Q9 region that sells units more than overall 
select region,
sum(units_sold) as total_units_sold 
from bmw_2018
group by 1 
order by 2 desc
limit 1;

-- Q10 months total sales 
select year,month,
sum(units_sold) as total_units
from bmw_2018 
group by 1,2;

-- Q11 top 3 models by total revenue 
select model,
sum(revenue_eur) as total_revenue 
from bmw_2018
group by 1
order by 2 desc 
limit 3;

-- Q12 year growth compared to previous 
with cte as (select year,
sum(units_sold) as total_units
from bmw_2018
group by 1)
select *,
total_units-lag(total_units) over (order by year) as prev_sales
from cte;

-- Q13 region wise model popularity 
select region,model,
max(units_sold) as popularity
from bmw_2018
group by 1,2;

-- Q14 running total of revenue_eur
with cte as (select year,
sum(revenue_eur) as total_revenue 
from bmw_2018
group by 1)
select *,
sum(total_revenue) over (order by year) as running_total
from cte;

-- Q15 top selling model by year 
with cte as (select year,
model,
sum(units_sold) as total_units
from bmw_2018
group by 1,2)
select *,
dense_rank() over (partition by year order by total_units desc) as rank_
from cte;

-- Q16 month wise moving average of units_sold 
with cte as (select year,month,
sum(units_sold) as total_units 
from bmw_2018 
group by 1,2)
select *,
round(avg(total_units) over (order by year,month rows between 2 preceding and current row),2) as running_avg 
from cte;

-- Q17 region % contribution in total revenue 
select region,
sum(revenue_eur) as total_revenue,
concat(round(sum(revenue_eur) * 100/
sum(sum(revenue_eur)) over (),2),'%') as percentage
from bmw_2018
group by 1;

-- Q18 year over year revenue growth in % 
with cte as (select year,
sum(revenue_eur) as total_revenue 
from bmw_2018
group by 1)
select *,
concat(round((total_revenue-lag(total_revenue) over (order by year)) * 100/
(lag(total_revenue) over (order by year)),2),'%') as percentage 
from cte;

select * from bmw_2018;
SET SQL_SAFE_UPDATES = 0;
