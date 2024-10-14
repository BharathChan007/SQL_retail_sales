-- SQL Retail Sales Analysis - p1

--- Creating Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
		transactions_id INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id INT,
		gender VARCHAR(15) ,
		age INT,
		category VARCHAR(15),
		quantiy INT,
		price_per_unit FLOAT,
		cogs FLOAT,
		total_sale FLOAT
	);

SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

--- DATE CLEANING

DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	category IS NULL
	OR
	quantiy IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

---- DATA EXPLORATION

---- HOW MANY RECORDS DO WE HAVE
SELECT COUNT(*) as total_sales FROM retail_sales

--- HOW MANY UNIQUE CUSTOMERS DO WE HAVE
SELECT COUNT(DISTINCT customer_id) FROM retail_sales

---- Data Analysis & Business Key Problems & Answers----

--Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

SELECT *
FROM retail_sales
WHERE category = 'Clothing' 
	AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11' 
	AND quantiy = 4

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category

SELECT category, 
	sum(total_sale) AS net_sale,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT ROUND(AVG(age)) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

-- Q.5Write a SQL query to find all transactions where the total_sale is greater than 1000.:

SELECT * FROM retail_sales
WHERE total_sale > 1000

--Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT category, gender, count(*)
FROM retail_sales
GROUP BY category, gender

--Q. 7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT * FROM
(
	SELECT
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as avg_sale,
		RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC)
	FROM retail_sales
	GROUP BY 1, 2
) as t1
WHERE RANK = 1

--Q.8 Write a SQL query to find the number of unique customers who purchased items from each category.:

SELECT category, COUNT(DISTINCT(customer_id))
FROM retail_sales
GROUP BY 1

--Q.9 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q. 10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

WITH hourly_sale
AS
(
SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) <= 12 THEN 'Morning'
		WHEN EXTRACT(HOUR from sale_time) between 12 and 17 THEN 'Afternoon'
		ELSE 'evening'
	END AS shift
from retail_sales
)
SELECT shift, count(*) AS total_orders
FROM hourly_sale
GROUP BY shift

--END OF PROJECT--