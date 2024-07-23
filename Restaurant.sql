-- Restaurant Analysis

-- 1. Total restaurants in each city

select city, count(restaurant_id)
from restaurants
group by city

-- 2. Total restaurants in each state

select state,count(restaurant_id)
from restaurants
group by state

-- 3. Restaurants COUNT by alcohol service

select  alcohol_service, count(restaurant_id) as count
from restaurants
group by alcohol_service

-- 4. Restaurants Count by Smoking Allowed

select smoking_allowed ,count(restaurant_id) as count
from restaurants
group by smoking_allowed

-- 5. Alcohol & Smoking analysis

select alcohol_service,smoking_allowed,count(restaurant_id) as total_restuarant
from restaurants
group by alcohol_service,smoking_allowed
order by 3 desc

-- 6. Restaurants COUNT by Price

select price,count(restaurant_id) as total_restaurants
from restaurants
group by price

-- 7. Restaurants COUNT by parking

select parking ,count(restaurant_id) as total_restaurants
from restaurants
group by parking
order by total_restaurants desc

-- 8. Count of Restaurants by cuisines

select cuisine,count(restaurant_cuisines) as total_restaturant
from restaurant_cuisines
group by cuisine
order by 2 desc

-- 9. Preferred cuisines of each customer

select distinct(name) as Restaurant_Name, count(cuisine) as No_of_cuisine,
string_agg(cuisine, ', ') as cuisines
from restaurants r
join restaurant_cuisines rc
on r.restaurant_id = rc.restaurant_id
group by 1
order by 2 desc

-- 10. Restaurant Price-Analysis for each cuisine

SELECT rs.cuisine,
SUM(CASE WHEN r.price = 'High' THEN 1 ELSE 0 END) AS High,
SUM(CASE WHEN r.price = 'Medium' THEN 1 ELSE 0 END) AS Medium,
SUM(CASE WHEN r.price = 'Low' THEN 1 ELSE 0 END) AS Low
FROM
    restaurants r
JOIN
    restaurant_cuisines rs ON r.restaurant_id = rs.restaurant_id
GROUP BY
    rs.cuisine
ORDER BY
    rs.cuisine DESC;

-- 11. Finding out COUNT of each cuisine in each state

SELECT   cuisine,
	     SUM(CASE WHEN state = 'Morelos' THEN 1 ELSE 0 END) as Morelos,
	     SUM(CASE WHEN state = 'San Luis Potosi' THEN 1 ELSE 0 END) as San_Luis_Potosi,
	     SUM(CASE WHEN state = 'Tamaulipas' THEN 1 ELSE 0 END) as Tamaulipas
FROM 	 restaurant_cuisines as a JOIN restaurants as b USING(restaurant_id)
GROUP BY 1
ORDER BY 1


-- Customer Demographics Analysis

-- 12. Total Customers in each state

select state, count(consumer_id) as Total_Customers
from customer_details
group by state 
order by Total_Customers desc

-- 13. Total Customers in each city	

select city ,count(consumer_id) as Total_Customers
from Customer_details
group by city
order by Total_Customers desc

-- 14. Budget level of customers

select budget ,count(consumer_id) as Budget
from Customer_details
group by Budget

-- 15. Total Smokers by Occupation

select smoker ,count(customer_details) as smokers
from customer_details
where smoker='Yes'
group by smoker

-- 16.Drinking level of students

select drink_level,count(customer_details) as Drinkiers
from customer_details
where occupation ='Student'
group by drink_level

-- 16.Transportation methods of customers

select transportation_method,count(customer_details) as Transport
from Customer_details
where transportation_method is not null
group by transportation_method

-- 17.Adding Age Bucket Column

alter table customer_details
add column age_bucket varchar(50)

-- 18.Updating the Age Bracket column with case when condition

UPDATE customer_details
SET age_bucket = 
		 CASE WHEN age > 60 then '61 and Above'
		      WHEN age > 40 then '41 - 60'	
		      WHEN age > 25 then '26 - 40'
		      WHEN age >= 18 then '18 - 25'
		    END
WHERE age_bucket is null

-- 19. Total customers in each age bucket

select age_bucket,count(consumer_id) as No_of_people
	from customer_details
	group by age_bucket
	order by 2 desc

-- 20. Total customers COUNT & smokers COUNT in each age percent

select age_bucket,count(consumer_id) as total,
    count(case when smoker='Yes' then consumer_id end) as smokers_count
	from customer_details
	group by age_bucket
	order by 1

-- 21. Top 10 preferred cuisines

select preferred_cuisine,count(consumer_id) as count
	from Customer_preference
	group by preferred_cuisine 
	order by 2 desc
	limit 10
	
-- 22. Preferred cuisines of each customer

select consumer_id,count(preferred_cuisine) as total_cuisine,
string_agg( preferred_cuisine, ' ,') as cuisine
from customer_preference
group by 1
order by 2 desc
	
-- 23. Customer Budget analysis for each cuisine

SELECT   b.preferred_cuisine,
		 SUM(CASE WHEN a.budget = 'High' Then 1 Else 0 END) AS High,
		 SUM(CASE WHEN a.budget = 'Medium' Then 1 Else 0 END) AS Medium,
		 SUM(CASE WHEN a.budget = 'Low' Then 1 Else 0 END) AS Low
FROM 	 customer_details a JOIN customer_preference b
ON b.consumer_id= a.consumer_id
GROUP BY 1
ORDER BY 1

-- 24. Finding out number of preferred cuisine in each state

select cd.state, count(pc.preferred_cuisine) as Count
from customer_details cd
join customer_preference pc
on cd.consumer_id=pc.consumer_id
group by 1 
order by 2 desc

select*
from customer_details

select*
from customer_preference



	