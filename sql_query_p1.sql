Create table retail_sales (
transactions_id	INT PRIMARY KEY,
sale_date DATE,	
sale_time TIME,	
customer_id	INT,
gender	VARCAHR(15),
age	INT,
category VARCAHR(15),
quantiy	INT,
price_per_unit	FLOAT,
cogs FLOAT,
total_sale FLOAT
);

--DATA CLEANING--

select * from retail_sales

select * from retail_sales
where transactions_id is null
	or
sale_date is null
	or
sale_time is null
	or
customer_id is null
	or
age is null
	or 
category is null
	or 
quantity is null
	or 
price_per_unit is null
	or 
cogs is null
	or 
total_sale is null

update retail_sales
set age = 20
where age is null;

delete from retail_sales
where category is null
or 
quantity is null
or 
price_per_unit is null
or 
cogs is null
or 
total_sale is null;

select * from retail_sales

--DATA EXPLORATION--

--How many sales do we have?--
select count (*) as total_sale
from retail_sales

--How many unique customers do we have?
select count (DISTINCT customer_id) as total_sale
	from retail_sales

--How many categories do we have?
select DISTINCT category from retail_sales

--DATA ANALYSIS AND BUSINESS PROBLEMS

--Write a SQL query to retrieve all columns for sales made on '10-04-2022'
select * from retail_sales
where sale_date = '10-04-2022';

--Write a SQL query to retrieve all transactions where the category is 'clothing' and the quantity sold is more than 4 in the month of 
--Nov 2022

select 
	*
from retail_sales
where category = 'Clothing'
	and
	to_char(sale_date, 'mm-yyyy')= '11-2022'
	and
	quantity >=4

--Write a SQL query to calculate the total sales (total_sale) for each category

select 
	category,
	sum(total_sale)as net_sales
from retail_sales
group by 1

--Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category

select 
	round(avg(age),2) as avg_age
from retail_sales
where category='Beauty'

--Write a SQL query to find all transactions where the total_sale is greater than 1000.

select
	*
from retail_sales
where total_sale >1000

--Write a SQL query to find total number of transactions (transaction_id) made by each gender in each category

select 
	category,
	gender,
count(*) as total_transactions
from retail_sales
group by
	category,
	gender
order by 1

--Write a SQL query to calculate the average sale for each month. Find out the best selling month in each year

select 
	year,
	month,
	avg_sale
from
(
	Select
		extract(year from sale_date) as year,
		extract(month from sale_date) as month,
		avg(total_sale) as avg_sale,
		rank() over (partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
	from retail_sales
	group by 1, 2
) as best_selling_month
where rank = 1

--Write a SQL query to find the top 5 customers based on the highest total sales

select 
	customer_id,
	sum(total_sale) as total_Sales
from retail_sales
	group by 1
	order by 2 desc
	limit 5

--Write a SQL query to find the number of unique customers who purchased items from each category 

select
	category,
	count(distinct customer_id) as unique_customers
from retail_sales
	group by 1

--Write a SQL query to create each shift and number of orders (eg: morning <=12, afternoon between 12 & 17, evening >17)

with hourly_sales
as
(
select *,
		case
		when extract(hour from sale_time) <12 then 'Morning'
		when extract(hour from sale_time) between 12 and 17 then'Afternoon'
		when extract(hour from sale_time) between 17 and 20 then'Evening'
		else 'Night'
	End as Shift 
from retail_sales
)
select
	shift,
	count(*) as total_orders 
from hourly_sales
group by shift

--END OF THE PROJECT--

