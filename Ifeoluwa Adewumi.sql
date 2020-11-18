create TABLE ib (
SALES_ID INT NOT NULL auto_increment,
SALES_REP varchar(255) NOT NULL,
EMAILS varchar(255) NOT NULL,
BRANDS varchar(255) NOT NULL,
PLANT_COST decimal(10, 2) NOT NULL,
UNIT_PRICE  decimal(10, 2) NOT NULL,
QUANTITY    int NOT NULL,
COST   decimal(10, 2) NOT NULL,
PROFIT decimal(10, 2) NOT NULL, 
COUNTRIES varchar(255) NOT NULL,
REGION   varchar(255) NOT NULL,
MONTHS    varchar(255) NOT NULL,
YEARS INT NOT NULL,
PRIMARY KEY (SALES_ID)    
);


select * FROM ib;

LOAD DATA INFILE 'ib.csv'
INTO table ib
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
lines terminated by '\n'
ignore 1 rows;

-- Session A: PROFIT ANALYSIS
select years, sum(profit)
from ib;
-- There are only three years in the dataset so we sum over the whole dataset
-- Total profit = 105587420.00

select sum(profit) as anglophone_profit
from ib
where countries in ('Ghana', 'Nigeria');
-- anglophone_profit 42,389,260

select sum(profit) as francophone_profit
from ib
where countries in ('Togo', 'Benin', 'Senegal');
-- francophone_profit = 63198160.00

select countries, sum(profit) as national_profit
from ib
group by countries
order by national_profit desc
limit 1;
-- Senegal is the country with the highest profit 

select years, sum(profit) as annual_profit
from ib
group by years
order by annual_profit desc
limit 1;
-- 2017 is the year with the highest annual profit, of 38,503,320

select months, years, sum(profit) as monthly_profit
from ib
group by years, months
order by monthly_profit;  
-- February 2019 had the least monthly profit of 1,366,880

select *
from ib
where (months, years) = ("December", "2018")
order by profit;
-- 	On an individual-region-salesperson level, minimum December 2018 profit was from sales rep	Jones for brand hero with 38150.00 in profit from	Senegal	northcentral

select *
from ib
where (months, years) = ("December", "2018")
group by brands
order by profit;
-- Trophy was the brand that produced the least profit in December of 2018 with a profit of 38,200

select months, years, profit, (sum(profit)/b.last_annual_profit * 100) as profit_in_percentage
from ib as i
	join (select sum(profit) as last_annual_profit 
		from ib where years = 2019) as b 
where years = 2019
group by months;


select brands, sum(profit) as brand_profit
from ib
where countries = "Senegal"
group by brands
order by brand_profit desc;
-- castle light is the brand with the highest profit in Senegal over the years

-- Session B: BRAND ANALYSIS

select brands, sum(quantity) as total_quantity
from ib
where countries in ('Togo', 'Benin', 'Senegal') and years in (2018, 2019)
group by brands
order by total_quantity desc
limit 3;
-- The 3 bestselling brands from the Francophone countries within the last two years: trophy, hero, eagle lager

select brands, sum(quantity) as total_quantity
from ib
where countries = "Ghana"
group by brands
order by total_quantity desc
limit 2;
-- The 2 bestselling consumer brands in Ghana are eagle lager and castle lite

select brands, sum(quantity) as total_quantity, sum(profit) as total_profit
from ib
where countries = "Nigeria" and brands in ('trophy', 'castle lite', 'eagle lager', 'budweiser', 'hero')
group by brands
order by total_quantity desc;
-- budweiser, eagle lager and hero are the 3 bestselling beers in the most oil-rich country in West Africa


-- malt brands = 'beta malt', 'grand malt' 
-- beers = 'trophy', 'castle lite', 'eagle lager', 'budweiser', 'hero'

select brands, sum(quantity) as total_quantity
from ib
where countries in ("Ghana", "Nigeria") and years in (2018, 2019) and brands in ('beta malt', 'grand malt')
group by brands
order by total_quantity desc
limit 1;
-- Favorite malt brand in Anglophone region between 2018 and 2019 is grand malt

select brands, sum(quantity) as total_quantity
from ib
where countries = "Nigeria" and years = 2019
group by brands
order by total_quantity desc;
-- hero is the brand with the highest sales in Nigeria in 2019 followed by eagle lager and beta malt

select brands, sum(quantity) as total_quantity
from ib
where countries = "Nigeria" and region = "southsouth"
group by brands
order by total_quantity desc;
-- eagle lager is the favorite brand in the South-south region of Nigeria, followed by trophy and hero

select sum(quantity) as nigeria_beer_consumption
from ib
where countries = "Nigeria" and brands in ('trophy', 'castle lite', 'eagle lager', 'budweiser', 'hero');
-- Beer consumption in Nigeria is 129,260 units over the period of the dataset

-- budweiser consumption in various regions of Nigeria
select region, sum(quantity) as total_quantity
from ib
where countries = "Nigeria" and brands = 'budweiser'
group by region
order by total_quantity desc;
-- Western Nigeria had the highest level of budweiser consumption at 4620 units

-- budweiser consumption in various regions of Nigeria in 2019
select region, sum(quantity) as total_quantity
from ib
where countries = "Nigeria" and brands = 'budweiser' and years = 2019
group by region
order by total_quantity desc;
-- Southeast Nigeria had the highest level of budweiser consumption in 2019 at 1821 units


-- Session C: COUNTRIES ANALYSIS

-- Country with the highest consumption of beer; find out brands in beers
select countries, sum(quantity) as national_volume
from ib
where brands in ('trophy', 'castle lite', 'eagle lager', 'budweiser', 'hero')
group by countries
order by national_volume desc
limit 1;
-- Senegal is the country with the highest consumption of beer, at 129875


-- Highest sales personnel of Budweiser in Senegal
select sales_rep, emails, brands, sum(quantity) as total_sold
from ib
where brands = 'Budweiser' and countries = 'Senegal'
group by sales_rep
order by total_sold
limit 1;
-- Thompson is the top sales personnel of Budweiser in Senegal 


select countries, sum(profit) as total_profit
from ib
where years = 2019 and months in ('October', 'November', 'December')
group by countries
order by total_profit desc
limit 1;
-- Country with the highest profit of the fourth quarter in 2019 is Ghana