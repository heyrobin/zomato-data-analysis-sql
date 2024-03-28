use ZomatoDB

----------------- ###################### UNDERSTANDING THE DATA #################################### ---------------

select * from food

select * from menu


select * from orders

select * from restaurant

select * from users


-----------------################################################### ORDERS ###################################################-----------------

select * from orders;

--- # top columns
select order_date,sales_qty,sales_amount,currency from orders;

-- check currency 
select currency,count(currency) from orders
group by currency

select * from orders
where currency = 'USD'

select * from orders
where currency = 'INR'



-- total sales qty and total sales amount
select YEAR(order_date) as years
--,month(order_date) as months 
,sum(sales_qty) as total_orders,sum(sales_amount) as total_orders from orders
group by YEAR(order_date)
--,month(order_date)
order by YEAR(order_date)
--,month(order_date) 
;


select * from orders o join users u on o.user_id = u.user_id;


-----------------################################################### USERS ###################################################-----------------

select * from users


select age,count(age) as age_count from users
group by age
order by age

select gender, count(gender) as gender_count from users
group by gender


select age,gender, count(gender) as gender_count from users
group by age, gender
order by age

select Monthly_Income,count(Monthly_Income) from users
group by Monthly_Income


select Educational_Qualifications,COUNT(Educational_Qualifications) from users
group by Educational_Qualifications

-----------------################################################### RESTRAUNT ###################################################-----------------

select * from restaurant

--cities where restraunts are in 

select city,count(city) as restruant_count from restaurant
group by city
order by count(city) desc

-- cusines 
select cuisine,count(cuisine) from restaurant
group by cuisine
order by count(cuisine) desc

select * from restaurant
where cuisine is null


-----------------################################################### Food ###################################################-----------------
select * from food
select veg_or_non_veg, COUNT(veg_or_non_veg) from food
group by veg_or_non_veg

select item,count(item) from food
group by item
order by count(item) desc


select * from food
where item = 'Brownie with Ice Cream'

-----------------################################################### menu ###################################################-----------------
select * from menu


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
WHERE TABLE_NAME = 'food'

SET @query = 'SELECT ' + @columns + ' FROM food'

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
