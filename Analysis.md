# Zomato : restaurant aggregator and food delivery (Analysis)

**Author**: Robin Singh <br />
**Email**: HeyRobinSingh@gmail.com <br />
**Website**: https://heyrobin.github.io/ <br />
**LinkedIn**: https://www.linkedin.com/in/heyrobin/  <br />

:exclamation: If you find this repository helpful, please consider giving it a :star:. Thanks! :exclamation:


We have 5 total tables and all are relevent data in the database. We will take orders data and join the necessary tables in it

````sql
select * from orders o join users u on o.user_id = u.user_id join restaurant r on r.id = o.r_id;
with data as (
select order_date,sales_qty,sales_amount,currency,r.name as rest_name,email,age,gender,Marital_Status,Occupation,Monthly_Income,Educational_Qualifications,Family_size,u.name as user_name,city,rating,rating_count,cost,cuisine 
from orders o join users u on o.user_id = u.user_id join restaurant r on r.id = o.r_id)
select top 10 * from data;
````


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






