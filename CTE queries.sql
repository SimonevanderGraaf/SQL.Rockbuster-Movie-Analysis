-- SQL CTE query from the subquery to locate the top 5 customers from the top 10 cities, who’ve paid the highest total amount in rental movies to Rockbuster.

WITH average_amount_cte (customer_id, first_name, last_name, country, city) AS
(SELECT
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
E.country
ORDER BY 
COUNT(B.customer_id) DESC 
LIMIT 
10)
GROUP BY
E.country,
D.city
ORDER BY
COUNT(B.customer_id) DESC
LIMIT
10)
GROUP BY
B.customer_id, 
B.first_name,
B.last_name,
E.country,
D.city
ORDER BY 
SUM(A.amount) DESC
LIMIT 
5)
SELECT AVG (total_amount_paid)
FROM average_amount_cte


-- SQL CTE query from the subquery to find out how many of the top 5 customers are based within each of the 10 countries.

WITH top_5_count_cte (customer_id, first_name, last_name, country, city) AS
(SELECT
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
E.country
ORDER BY 
COUNT(B.customer_id) DESC 
LIMIT 
10)
GROUP BY
E.country,
D.city
ORDER BY
COUNT(B.customer_id) DESC
LIMIT
10)
GROUP BY
B.customer_id, 
B.first_name,
B.last_name,
E.country,
D.city
ORDER BY 
SUM(A.amount) DESC
LIMIT 
5)
SELECT 
E.country,
COUNT (DISTINCT B.customer_id) AS all_customer_count,
COUNT (DISTINCT top_5_count_cte) AS top_customer_count
FROM customer B
JOIN address C ON B.address_id = C.address_id
JOIN city D ON C.city_id = D.city_id
JOIN country E ON D.country_id = E.country_id
LEFT JOIN top_5_count_cte ON B.customer_id = top_5_count_cte.customer_id
GROUP BY
E.country
ORDER BY
all_customer_count DESC
LIMIT 10;