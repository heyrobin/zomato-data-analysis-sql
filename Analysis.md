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
            |




-- we have added restraunt and user data into the order table using the cte 
-- lets do checking for missing values and data cleaning and pre-processing


**1.**  List the total number of reported crimes between 2018 and 2023?

````sql abc
````


**Results:**

Total Reported Crimes| Total Reported Crimes|
---------------------|----------------------|
 1,450,979           |  1,450,979           |






To be continued....

:exclamation: If you find this repository helpful, please consider giving it a :star:. Thanks! :exclamation:






