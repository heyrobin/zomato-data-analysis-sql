# Zomato : restaurant aggregator and food delivery (Analysis)

**Author**: Robin Singh <br />
**Email**: HeyRobinSingh@gmail.com <br />
**Website**: https://heyrobin.github.io/ <br />
**LinkedIn**: https://www.linkedin.com/in/heyrobin/  <br />

:exclamation: If you find this repository helpful, please consider giving it a :star:. Thanks! :exclamation:


**1.**  List the total number of reported crimes between 2018 and 2023?

````sql
select * from orders o join users u on o.user_id = u.user_id join restaurant r on r.id = o.r_id;
with data as (
select order_date,sales_qty,sales_amount,currency,r.name as rest_name,email,age,gender,Marital_Status,Occupation,Monthly_Income,Educational_Qualifications,Family_size,u.name as user_name,city,rating,rating_count,cost,cuisine 
from orders o join users u on o.user_id = u.user_id join restaurant r on r.id = o.r_id)
select top 10 * from data;

````

**Results:**

Total Reported Crimes|
---------------------|
 1,450,979           |


To be continued....

:exclamation: If you find this repository helpful, please consider giving it a :star:. Thanks! :exclamation:






