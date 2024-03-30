use ZomatoDB

-----------------################################################### Analysis ###################################################-----------------

-- We have 5 total tables and all are relevent data in the database. We will take orders data and join the necessary tables in it

select * from orders o join users u on o.user_id = u.user_id join restaurant r on r.id = o.r_id;
with data as (
select order_date,sales_qty,sales_amount,currency,r.name as rest_name,email,age,gender,Marital_Status,Occupation,Monthly_Income,Educational_Qualifications,Family_size,u.name as user_name,city,rating,rating_count,cost,cuisine 
from orders o join users u on o.user_id = u.user_id join restaurant r on r.id = o.r_id)
select top 10 * from data;

-- we have added restraunt and user data into the order table using the cte 

-- lets do data cleaning and pre-processing

-- checking for missing values 

with data as (
select order_date,sales_qty,sales_amount,currency,r.name as rest_name,email,age,gender,Marital_Status,Occupation,Monthly_Income,Educational_Qualifications,Family_size,u.name as user_name,city,rating,rating_count,cost,cuisine 
from orders o join users u on o.user_id = u.user_id join restaurant r on r.id = o.r_id)
select top 10 * from data



select * into #temp_data
FROM (
    SELECT 
        order_date,
        sales_qty,
        sales_amount,
        currency,
        r.name AS rest_name,
        email,
        age,
        gender,
        Marital_Status,
        Occupation,
        Monthly_Income,
        Educational_Qualifications,
        Family_size,
        u.name AS user_name,
        city,
        rating,
        rating_count,
        cost,
        cuisine 
    FROM 
        orders o 
        JOIN users u ON o.user_id = u.user_id 
        JOIN restaurant r ON r.id = o.r_id
) AS zom_db;

select * from #temp_data;

SELECT 
    COUNT(*) AS total_rows,
    COUNT(CASE WHEN order_date IS NULL THEN 1 END) AS order_date,
    COUNT(CASE WHEN sales_qty IS NULL THEN 1 END) AS sales_qty,
    COUNT(CASE WHEN sales_amount IS NULL THEN 1 END) AS sales_amount,
    COUNT(CASE WHEN currency IS NULL THEN 1 END) AS currency,
    COUNT(CASE WHEN rest_name IS NULL THEN 1 END) AS rest_name,
    COUNT(CASE WHEN email IS NULL THEN 1 END) AS email,
    COUNT(CASE WHEN age IS NULL THEN 1 END) AS age,
    COUNT(CASE WHEN gender IS NULL THEN 1 END) AS gender,
    COUNT(CASE WHEN Marital_Status IS NULL THEN 1 END) AS Marital_Status,
    COUNT(CASE WHEN Occupation IS NULL THEN 1 END) AS Occupation,
    COUNT(CASE WHEN Monthly_Income IS NULL THEN 1 END) AS Monthly_Income,
    COUNT(CASE WHEN Educational_Qualifications IS NULL THEN 1 END) AS Educational_Qualifications,
    COUNT(CASE WHEN Family_size IS NULL THEN 1 END) AS Family_size,
    COUNT(CASE WHEN user_name IS NULL THEN 1 END) AS user_name,
    COUNT(CASE WHEN city IS NULL THEN 1 END) AS city,
    COUNT(CASE WHEN rating IS NULL THEN 1 END) AS rating,
    COUNT(CASE WHEN rating_count IS NULL THEN 1 END) AS rating_count,
    COUNT(CASE WHEN cost IS NULL THEN 1 END) AS cost,
    COUNT(CASE WHEN cuisine IS NULL THEN 1 END) AS cuisine
FROM 
    #temp_data;


--- lets make it short and make using dynamic SQL

DECLARE @columns NVARCHAR(MAX)
DECLARE @query NVARCHAR(MAX)

SELECT @columns = STRING_AGG('COUNT(' + QUOTENAME(column_name) + ') AS ' + column_name, ', ')
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'orders'

SET @query = 'SELECT ' + @columns + ' FROM orders'

EXEC sp_executesql @query



-- Convert Data Types:

ALTER TABLE orders
ALTER COLUMN order_date DATETIME;

-- there are problem with currency columns that there are diffrent inr 

select currency from #temp_data
group by currency

-- there are problem with currency columns that there are diffrent inr 

update orders
set currency = case when currency = 'USD' then 'USD' else 'INR' end;

select currency from orders
group by currency


--------------------------######################################## Summary Statistics:

-- summary stats for sales


WITH Mode AS (
    SELECT TOP 1 sales_amount AS mode
    FROM #temp_data
    GROUP BY sales_amount
    ORDER BY COUNT(sales_amount) DESC
),
Median AS (
    SELECT TOP 1 PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY sales_amount ASC) OVER() AS median
    FROM #temp_data
)
SELECT
    (SELECT mode FROM Mode) AS mode,
    (SELECT median FROM Median) AS median,
    AVG(sales_amount) AS mean,
    MIN(sales_amount) AS min,
    MAX(sales_amount) AS maximum
FROM
    #temp_data;

-- Frequency Analysis:

SELECT 
    gender,
    COUNT(*) AS count
FROM #temp_data
GROUP BY gender;

-- Distribution Analysis:
SELECT 
    age,
    COUNT(*) AS frequency
FROM #temp_data
GROUP BY age
ORDER BY age;



--------------------------######################################## Sales Analysis:

-- Total Sales Revenue:
--- year 2019

SELECT 
    DATENAME(MONTH, order_date) AS month,
    SUM(sales_amount) AS total_sales
FROM #temp_data
WHERE YEAR(order_date) = 2019
GROUP BY DATENAME(MONTH, order_date), MONTH(order_date)
ORDER BY MONTH(order_date) ASC;



-- Top-selling items or cuisines:
SELECT 
    cuisine,
    SUM(sales_qty) AS total_sales_quantity,
    SUM(sales_amount) AS total_sales_revenue
FROM #temp_data
GROUP BY cuisine
ORDER BY total_sales_revenue DESC;

-- Top-selling items or cuisines:
SELECT 
    cuisine,
    SUM(sales_qty) AS total_sales_quantity,
    SUM(sales_amount) AS total_sales_revenue
FROM #temp_data
GROUP BY cuisine
ORDER BY total_sales_revenue DESC;

-- Sales Trends Over Time:
SELECT 
    YEAR(order_date) AS year,
    DATENAME(MONTH, order_date) AS month,
    SUM(sales_amount) AS total_sales
FROM #temp_data
GROUP BY YEAR(order_date), DATENAME(MONTH, order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date) ASC;

-- 5. Average Order Value:
SELECT 
    AVG(sales_amount) AS average_order_value
FROM #temp_data;

-- 6. top 10 Sales Contribution by Restaurants:

SELECT top 10
    rest_name,
    SUM(sales_amount) AS total_sales_revenue
FROM #temp_data
GROUP BY rest_name
ORDER BY total_sales_revenue DESC;

--------------------------######################################## Customer Analysis:

-- 1.Customer Demographics:
-- Analyze the distribution of customers by demographics such as age, gender, marital status, occupation, and educational qualifications:

SELECT 
    age,
    gender,
    marital_status,
    occupation,
    educational_qualifications,
    COUNT(*) AS customer_count
FROM #temp_data
GROUP BY age, gender, marital_status, occupation, educational_qualifications
ORDER BY age;


-- 2.Customer Retention Rates:
-- Calculate customer retention rates over time to understand how many customers return to make repeat purchases:

SELECT 
    CONVERT(varchar(7), order_date, 120) AS month,
    COUNT(DISTINCT user_name) AS returning_customers
FROM #temp_data
GROUP BY  CONVERT(varchar(7), order_date, 120)
ORDER BY month;


-- 3.Average Order Frequency:
-- Calculate the average frequency of orders per customer to understand their buying behavior:

SELECT 
    user_name,
    COUNT(*) AS total_orders,
    COUNT(*) / NULLIF(DATEDIFF(MONTH, MIN(order_date), MAX(order_date)), 0) AS avg_order_frequency
FROM #temp_data
GROUP BY user_name
ORDER BY total_orders DESC;

-- 4. Customer Lifetime Value (CLV):
-- Estimate the CLV for each customer to understand their long-term value to the business:

SELECT 
    user_name,
    SUM(sales_amount) AS total_sales_amount,
    COUNT(*) AS total_orders,
    SUM(sales_amount) / COUNT(*) AS avg_order_value
FROM #temp_data
GROUP BY user_name
ORDER BY total_sales_amount DESC;

-- 5.Segmentation Analysis:
---Segment customers based on their characteristics or behavior and analyze their purchasing patterns:


with cte as (
SELECT 
    CASE 
        WHEN age < 30 THEN 'Young'
        WHEN age >= 30 AND age < 50 THEN 'Middle-aged'
        ELSE 'Elderly'
    END AS age_group,gender
FROM 
    #temp_data)

select age_group,gender,count(gender) as counts from cte
group by age_group,gender

--------------------------######################################## Pricing Analysis:


--1. rice Distribution:

---Calculate the distribution of prices for different items or cuisines:

SELECT top 10
    cuisine,
    AVG(cost) AS average_price,
    MIN(cost) AS min_price,
    MAX(cost) AS max_price
FROM #temp_data
GROUP BY cuisine
ORDER BY average_price DESC;


--2. Price vs. Sales Performance:
--- Analyze the relationship between pricing and sales performance to identify optimal price points:

SELECT 
    cuisine,
    AVG(cost) AS average_price,
    SUM(sales_amount) AS total_sales_revenue
FROM #temp_data
GROUP BY cuisine
ORDER BY total_sales_revenue DESC;

-- Price Elasticity:
--- Estimate price elasticity to understand how changes in price impact sales volume:

SELECT 
    cuisine,
    AVG(cost) AS average_price,
    SUM(sales_qty) AS total_sales_quantity
FROM #temp_data
GROUP BY cuisine
ORDER BY total_sales_quantity DESC;

-- Price Tier Analysis:
--- Segment items or cuisines into price tiers and analyze sales performance within each tier:


with cte as 

(
SELECT 
    CASE 
        WHEN cost < 100 THEN 'Low'
        WHEN cost >= 100 AND cost < 200 THEN 'Medium'
        ELSE 'High' END AS price_tier
, sales_qty
from #temp_data)

select price_tier ,count(*) as item_count ,sum(sales_qty) as total_sales_quantity from cte
group by price_tier


