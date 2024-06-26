-- SQL query to find the average amount paid by the top 5 customers I identified in the JOIN queries file.

SELECT AVG(total_amount_paid) AS average
FROM
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
10
)
GROUP BY
E.country,
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
5) AS total_amount_paid


-- SQL query to find out how many of the top 5 customers are based within each of the 10 countries.

SELECT 
E.country,
COUNT (DISTINCT B.customer_id) AS all_customer_count,
COUNT (DISTINCT top_5_customers) AS top_customer_count
FROM customer B
JOIN address C ON B.address_id = C.address_id
JOIN city D ON C.city_id = D.city_id
JOIN country E ON D.country_id = E.country_id
LEFT JOIN
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
10
)
GROUP BY
E.country,
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
5)top_5_customers ON B.customer_id = top_5_customers.customer_id
GROUP BY
E.country
ORDER BY
all_customer_count DESC
LIMIT 10;