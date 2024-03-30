# Zomato : restaurant aggregator and food delivery (Analysis)

**Author**: Robin Singh <br />
**Email**: HeyRobinSingh@gmail.com <br />
**Website**: https://heyrobin.github.io/ <br />
**LinkedIn**: https://www.linkedin.com/in/heyrobin/  <br />

:exclamation: If you find this repository helpful, please consider giving it a :star:. Thanks! :exclamation:


We have 5 total tables and all are relevent data in the database. We will take orders data and join the necessary tables in it

````sql
WITH data AS (
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
)
SELECT TOP 10 
    * 
FROM 
    data;

````

**Results:**

| Order Date          | Sales Qty | Sales Amount | Currency | Restaurant Name            | Email                   | Age | Gender | Marital Status | Occupation    | Monthly Income   | Educational Qualifications | Family Size | User Name       | City   | Rating | Rating Count | Cost  | Cuisine                 |
|---------------------|-----------|--------------|----------|----------------------------|-------------------------|-----|--------|----------------|---------------|------------------|----------------------------|-------------|-----------------|--------|--------|--------------|-------|-------------------------|
| 2017-10-10 00:00:00 | 100       | 41241        | INR      | AB FOODS POINT             | crobertson@example.com | 27  | Male   | Married        | Self Employed | 25001 to 50000  | Graduate                   | 6           | Teresa Garcia   | Abohar | NULL   | Too Few Ratings | 200.00| Beverages,Pizzas        |
| 2018-05-08 00:00:00 | 3         | -1           | INR      | Janta Sweet House          | tonidecker@example.net | 23  | Male   | Single         | Student       | More than 50000 | Post Graduate              | 3           | Dana Reeves     | Abohar | 4.4    | 50+ ratings    | 200.00| Sweets,Bakery           |
| 2018-04-06 00:00:00 | 1         | 875          | INR      | theka coffee desi          | vritter@example.org    | 24  | Male   | Married        | Employee      | More than 50000 | Post Graduate              | 3           | Donald Anderson | Abohar | 3.8    | 100+ ratings   | 100.00| Beverages               |
| 2018-04-11 00:00:00 | 1         | 583          | INR      | Singh Hut                  | rodriguezjessica@example.net | 22 | Male   | Single         | Student       | Below Rs.10000  | Post Graduate              | 3           | Scott Cruz      | Abohar | 3.7    | 20+ ratings    | 250.00| Fast Food,Indian        |


we have added restraunt and user data into the order table using the cte but in order to keep everything small we have created a 1 combined temp table

````sql
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
````
````sql
select * from #temp_data;
````

Lets do checking for missing values and data cleaning and pre-processing

lets make it short and make using dynamic SQL
````sql
DECLARE @columns NVARCHAR(MAX)
DECLARE @query NVARCHAR(MAX)

SELECT @columns = STRING_AGG('COUNT(' + QUOTENAME(column_name) + ') AS ' + column_name, ', ')
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'orders'

SET @query = 'SELECT ' + @columns + ' FROM orders'

EXEC sp_executesql @query
````




Checking for missing values 

````sql
with data as (
select order_date,sales_qty,sales_amount,currency,r.name as rest_name,email,age,gender,Marital_Status,Occupation,Monthly_Income,Educational_Qualifications,Family_size,u.name as user_name,city,rating,rating_count,cost,cuisine 
from orders o join users u on o.user_id = u.user_id join restaurant r on r.id = o.r_id)
select top 10 * from data 

````

**Results:**

| Order Date | Sales Qty | Sales Amount | Currency | Restaurant ID | User ID |
|------------|-----------|--------------|----------|---------------|---------|
|   150281   |   150281  |    150281    |   150281 |     148664    |  150281 |



-- Convert Data Types:

````sql
ALTER TABLE orders
ALTER COLUMN order_date DATETIME;
````

-- there are problem with currency columns that there are diffrent inr 

````sql
select currency from #temp_data
group by currency
````

-- there are problem with currency columns that there are diffrent inr 

````sql
update orders
set currency = case when currency = 'USD' then 'USD' else 'INR' end;

select currency from orders
group by currency
````

**1.**  Summary stats for sales

````sql
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

````

**Results:**

| Mode | Median | Mean | Min | Maximum |
|------|--------|------|-----|---------|
|  93  |  495   | 6486 |  -1 | 1510944 |


**2.**  Frequency Analysis:

````sql
SELECT 
    gender,
    COUNT(*) AS count
FROM #temp_data
GROUP BY gender;
````

**Results:**

| Gender | Count  |
|--------|--------|
|  Male  | 84992  |
| Female | 63672  |


**3.**  Distribution Analysis:
````sql
SELECT 
    age,
    COUNT(*) AS frequency
FROM #temp_data
GROUP BY age
ORDER BY age;
````

**Results:**

| Age | Frequency |
|-----|-----------|
|  18 |    383    |
|  19 |   1579    |
|  20 |   3397    |
|  21 |   8772    |
|  22 |  21595    |
|  23 |  27762    |
|  24 |  19300    |
|  25 |  20174    |
|  26 |  13651    |
|  27 |   8042    |
|  28 |   5643    |
|  29 |   5445    |
|  30 |   3413    |
|  31 |   3068    |
|  32 |   6070    |
|  33 |    370    |



**4.**  Total Sales Revenue of year 2019

````sql
SELECT 
    DATENAME(MONTH, order_date) AS month,
    SUM(sales_amount) AS total_sales
FROM #temp_data
WHERE YEAR(order_date) = 2019
GROUP BY DATENAME(MONTH, order_date), MONTH(order_date)
ORDER BY MONTH(order_date) ASC;
````

**Results:**

|   Month   | Total Sales |
|-----------|-------------|
|  January  |  30766072   |
| February  |  26438028   |
|   March   |  27387931   |
|   April   |  26810140   |
|    May    |  27860646   |
|   June    |  25178015   |
|   July    |  34909292   |
|  August   |  31945288   |
| September |  24880596   |
|  October  |  26449670   |
| November  |  26267629   |
| December  |  22453862   |

**5.**  Top-selling items or cuisines:

````sql
SELECT 
    cuisine,
    SUM(sales_qty) AS total_sales_quantity,
    SUM(sales_amount) AS total_sales_revenue
FROM #temp_data
GROUP BY cuisine
ORDER BY total_sales_revenue DESC;
````

**Results:**

|     Cuisine           | Total Sales Quantity | Total Sales Revenue |
|-----------------------|----------------------|---------------------|
| North Indian,Chinese  |         121654       |       44956268      |
| Indian                |          98522       |       42626090      |
| North Indian          |          91190       |       33670996      |
| Chinese               |          77833       |       27259296      |
| Indian,Chinese        |          73516       |       25738592      |



**6.**  Sales Trends Over Time:

````sql
SELECT 
    YEAR(order_date) AS year,
    DATENAME(MONTH, order_date) AS month,
    SUM(sales_amount) AS total_sales
FROM #temp_data
GROUP BY YEAR(order_date), DATENAME(MONTH, order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date) ASC;
````

**Results:**

|  Year |  Month   | Total Sales |
|-------|----------|-------------|
|  2017 | October  |  25257207   |
|  2017 | November |  33374480   |
|  2017 | December |  30659375   |
|  2018 | January  |  41751115   |
|  2018 | February |  34280116   |



**7.**  Average Order Value:

````sql
SELECT 
    AVG(sales_amount) AS average_order_value
FROM #temp_data;
````

**Results:**

| Average Order Value |
|---------------------|
|        6486         |


**8.** top 10 Sales Contribution by Restaurants:

````sql
SELECT top 10
    rest_name,
    SUM(sales_amount) AS total_sales_revenue
FROM #temp_data
GROUP BY rest_name
ORDER BY total_sales_revenue DESC;
````

**Results:**

|              Restaurant Name             | Total Sales Revenue |
|------------------------------------------|---------------------|
|           Domino's Pizza                |       5025266       |
| Kouzina Kafe - The Food Court           |       1958408       |
| Sweet Truth - Cake and Desserts         |       1952881       |
|               Pizza Hut                  |       1792693       |
|             Biryani House                |       1711064       |
|            Huber & Holly                 |       1668292       |
|            Baskin Robbins                |       1627731       |
|                   KFC                    |       1605569       |
|      McCafe by McDonald's               |       1541849       |
|              Janta Snacks                |       1510944       |


----------------------------------

--------------------------######################################## Customer Analysis:

**9.** .Customer Demographics:
-- Analyze the distribution of customers by demographics such as age, gender, marital status, occupation, and educational qualifications:

````sql
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
````

**Results:**

| Age | Gender | Marital Status | Occupation | Educational Qualifications | Customer Count |
|-----|--------|----------------|------------|----------------------------|----------------|
|  18 |  Male  |     Single     |  Student   |          Graduate          |      383       |
|  19 | Female |     Single     |  Student   |          Graduate          |      416       |
|  19 |  Male  |     Single     |  Student   |          Graduate          |     1163       |
|  20 | Female |     Single     |  Student   |          Graduate          |      778       |



**10.** Customer Retention Rates:
-- Calculate customer retention rates over time to understand how many customers return to make repeat purchases:

````sql
SELECT 
    CONVERT(varchar(7), order_date, 120) AS month,
    COUNT(DISTINCT user_name) AS returning_customers
FROM #temp_data
GROUP BY  CONVERT(varchar(7), order_date, 120)
ORDER BY month;
````
**Results:**

|  Month  | Returning Customers |
|---------|---------------------|
| 2017-10 |        4049         |
| 2017-11 |        5146         |
| 2017-12 |        4678         |
| 2018-01 |        4950         |
| 2018-02 |        4709         |
| 2018-03 |        4900         |
| 2018-04 |        4813         |
| 2018-05 |        4956         |
| 2018-06 |        5172         |
| 2018-07 |        5059         |




**11.** Average Order Frequency:
-- Calculate the average frequency of orders per customer to understand their buying behavior:

````sql
SELECT 
    user_name,
    COUNT(*) AS total_orders,
    COUNT(*) / NULLIF(DATEDIFF(MONTH, MIN(order_date), MAX(order_date)), 0) AS avg_order_frequency
FROM #temp_data
GROUP BY user_name
ORDER BY total_orders DESC;
````

**Results:**

|   User Name    | Total Orders | Avg Order Frequency |
|----------------|--------------|---------------------|
|  David Smith   |      64      |          2          |
| Michael Brown  |      62      |          1          |
| Michael Smith  |      50      |          1          |
| Robert Smith   |      48      |          1          |
| Michael Miller |      47      |          1          |


**12.** Customer Lifetime Value (CLV):
-- Estimate the CLV for each customer to understand their long-term value to the business:

````sql
SELECT 
    user_name,
    SUM(sales_amount) AS total_sales_amount,
    COUNT(*) AS total_orders,
    SUM(sales_amount) / COUNT(*) AS avg_order_value
FROM #temp_data
GROUP BY user_name
ORDER BY total_sales_amount DESC;
````

**Results:**

|    User Name     | Total Sales Amount | Total Orders | Avg Order Value |
|------------------|--------------------|--------------|-----------------|
|  Amanda Ballard  |       1514634      |       3      |      504878     |
|  Gina Carpenter  |       1496625      |       4      |      374156     |
| Jonathan Vasquez |       1479283      |       5      |      295856     |
|   Lisa Aguirre   |       1478074      |       4      |      369518     |
|    Brian White   |       1366985      |      14      |       97641     |


**13.** Segmentation Analysis:
---Segment customers based on their characteristics or behavior and analyze their purchasing patterns:

````sql
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
````

**Results:**

|  Age Group   | Gender |  Counts |
|--------------|--------|---------|
|     Young    |  Male  |  76268  |
| Middle-aged  | Female |  4197   |
|     Young    | Female |  59475  |
| Middle-aged  |  Male  |  8724   |


----------------------------------
--------------------------######################################## Pricing Analysis:


**14.**  rice Distribution:

---Calculate the distribution of prices for different items or cuisines:

````sql
SELECT top 10
    cuisine,
    AVG(cost) AS average_price,
    MIN(cost) AS min_price,
    MAX(cost) AS max_price
FROM #temp_data
GROUP BY cuisine
ORDER BY average_price DESC;
````

**Results:**

|        Cuisine         | Average Price | Min Price | Max Price |
|------------------------|---------------|-----------|-----------|
| Sri Lankan,Seafood    |    3500.00    |  3500.00  |  3500.00  |
| Japanese,Mughlai      |    3000.00    |  3000.00  |  3000.00  |
| Seafood,Pastas        |    2000.00    |  2000.00  |  2000.00  |
| Goan,Italian          |    2000.00    |  2000.00  |  2000.00  |
| Asian,Turkish         |    2000.00    |  2000.00  |  2000.00  |
| Turkish,European      |    1800.00    |  1800.00  |  1800.00  |
| Salads,Seafood        |    1600.00    |  1600.00  |  1600.00  |
| Bakery,Turkish        |    1600.00    |  1600.00  |  1600.00  |
| Greek,Salads          |    1600.00    |  1600.00  |  1600.00  |
| Thai,Indonesian       |    1600.00    |  1600.00  |  1600.00  |



**15.**  Price vs. Sales Performance:
--- Analyze the relationship between pricing and sales performance to identify optimal price points:

````sql
SELECT 
    cuisine,
    AVG(cost) AS average_price,
    SUM(sales_amount) AS total_sales_revenue
FROM #temp_data
GROUP BY cuisine
ORDER BY total_sales_revenue DESC;
````

**Results:**

|     Cuisine          | Average Price | Total Sales Revenue |
|----------------------|---------------|---------------------|
| North Indian,Chinese|    365.0021   |       44956268      |
| Indian               |    263.9397   |       42626090      |
| North Indian         |    272.9893   |       33670996      |
| Chinese              |    266.6719   |       27259296      |
| Indian,Chinese       |    318.7485   |       25738592      |


**16.** Price Elasticity:
--- Estimate price elasticity to understand how changes in price impact sales volume:

````sql
SELECT 
    cuisine,
    AVG(cost) AS average_price,
    SUM(sales_qty) AS total_sales_quantity
FROM #temp_data
GROUP BY cuisine
ORDER BY total_sales_quantity DESC;
````

**Results:**

|     Cuisine          | Average Price | Total Sales Quantity |
|----------------------|---------------|----------------------|
| North Indian,Chinese|    365.0021   |        121654        |
| Indian               |    263.9397   |         98522        |
| North Indian         |    272.9893   |         91190        |
| Chinese              |    266.6719   |         77833        |
| Indian,Chinese       |    318.7485   |         73516        |


**17.** Price Tier Analysis:
--- Segment items or cuisines into price tiers and analyze sales performance within each tier:

````sql
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

````

**Results:**

| Price Tier | Item Count | Total Sales Quantity |
|------------|------------|----------------------|
|    High    |   124917   |       2051153        |
|     Low    |    1519    |         22248        |
|   Medium   |   22228    |        358030        |





To be continued....

:exclamation: If you find this repository helpful, please consider giving it a :star:. Thanks! :exclamation:






