-- Create TABLE 
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE  retail_sales (
	
	transactions_id		int primary key,
	sale_date			date,
	sale_time			time,
	customer_id			int,
	gender				varchar(15),
	age 				int,	
	category 			varchar(15),
	quantity			int,
	price_per_unit 		float,	
	cogs				float,
	total_sale 			float

);
-- Data test
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
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
-- Data cleaning 
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
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

SELECT	*
FROM 	retail_sales
WHERE	sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022

SELECT
	*
FROM	retail_sales
WHERE	category = 'Clothing'
		AND quantity > 3 
		AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT
	category,
	SUM(total_sale) as total_sales
FROM retail_sales 
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT 
	ROUND(AVG(age), 2) as avg_age_beauty_cus
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT *
FROM retail_sales 
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

SELECT 
	category,
	gender,
	COUNT(transactions_id) as num_transaction
FROM retail_sales
GROUP BY category, gender
ORDER BY category, gender;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT
	EXTRACT(year from sale_date) as year,
	EXTRACT(month from sale_date) as month,
	ROUND(AVG(total_sale)::numeric, 2) as avg_sale_by_month
FROM retail_sales
GROUP BY year, month
ORDER BY year, avg_sale_by_month desc;

	
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
WITH raw_data as 
(
	SELECT 
		customer_id,
		SUM(total_sale) as total_sales,
		DENSE_RANK() OVER(ORDER BY SUM(total_sale) DESC) as rank_cus
	FROM	retail_sales
	GROUP BY	customer_id
)

SELECT 
	customer_id,
	total_sales
FROM	raw_data
WHERE	rank_cus <= 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
	category, 
	COUNT(DISTINCT customer_id) as num_cus
FROM	retail_sales
GROUP BY	category 
ORDER BY	num_cus DESC;



-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

SELECT 
	CASE 
		WHEN EXTRACT(hour from sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(hour from sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening' END as shift,
	COUNT(*) as num_of_orders
FROM	retail_sales
GROUP BY 	shift
ORDER BY 	num_of_orders DESC

-- End of project 


