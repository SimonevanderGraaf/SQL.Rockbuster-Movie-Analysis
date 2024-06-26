-- SQL query to find the top 10 countries in the world for Rockbuster looking at the number of customers. 

SELECT
D.country,
COUNT(A.customer_id) AS number_of_customers
FROM
customer A
JOIN address B ON A.address_id = B.address_id
JOIN city C ON B.city_id = C.city_id
JOIN country D ON C.country_id = D.country_id
GROUP BY
D.country
ORDER BY
number_of_customers DESC
LIMIT
10


-- SQL query to identify the top 10 cities that fall within the top 10 countries I identified above.

SELECT
D.country,
C.city,
COUNT(A.customer_id) AS number_of_customers
FROM
customer A
JOIN address B ON A.address_id = B.address_id
JOIN city C ON B.city_id = C.city_id
JOIN country D ON C.country_id = D.country_id
WHERE
D.country IN (
SELECT 
D.country
FROM 
customer A
JOIN address B ON A.address_id = B.address_id
JOIN city C ON B.city_id = C.city_id
JOIN country D ON C.country_id = D.country_id
GROUP BY 
D.country
ORDER BY 
COUNT(A.customer_id) DESC 
LIMIT 
10
)
GROUP BY
D.country, C.city
ORDER BY
COUNT(A.customer_id) DESC 
LIMIT
10;


-- SQL query to locate the top 5 customers from the top 10 cities from the SQL query above, who’ve paid the highest total amount in rental movies to Rockbuster.

SELECT
B.customer_id, 
B.first_name,
B.last_name,
E.country,
D.city,
SUM (A.amount) AS total_amount_paid
FROM
payment A
JOIN customer B ON A.customer_id = B.customer_id
JOIN address C ON B.address_id = C.address_id
JOIN city D ON C.city_id = D.city_id
JOIN country E ON D.country_id = E.country_id
WHERE 
D.city in (
SELECT
D.city
FROM
customer B
JOIN address C ON B.address_id = C.address_id
JOIN city D ON C.city_id = D.city_id
JOIN country E ON D.country_id = E.country_id
WHERE
E.country IN (
SELECT 
E.country
FROM 
customer B
JOIN address C ON B.address_id = C.address_id
JOIN city D ON C.city_id = D.city_id
JOIN country E ON D.country_id = E.country_id
GROUP BY 
E.country,
ORDER BY 
COUNT(B.customer_id) DESC 
LIMIT 
10
)
GROUP BY
E.country
D.city
ORDER BY
COUNT(B.customer_id) DESC
LIMIT
10
)
GROUP BY
B.customer_id, 
B.first_name,
B.last_name,
E.country,
D.city
ORDER BY
SUM(A.amount) DESC
LIMIT
5;