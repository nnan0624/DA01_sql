---example 1
SELECT CO.CONTINENT, 
FLOOR(AVG(CI.POPULATION))
FROM COUNTRY CO
JOIN CITY CI ON CI.COUNTRYCODE =  CO.CODE
GROUP BY CO.CONTINENT

---example 2
SELECT ROUND(CAST(COUNT(t.email_id) AS DECIMAL)
    /CAST(COUNT(e.email_id) AS DECIMAL),2) AS activation_rate
FROM emails e
LEFT JOIN texts t ON t.email_id = e.email_id
AND t.signup_action = 'Confirmed'

---example 3
SELECT ab.age_bucket,
 ROUND((SUM(CASE WHEN a.activity_type = 'send' THEN a.time_spent ELSE 0 END)/
 (SUM(CASE WHEN a.activity_type = 'send' THEN a.time_spent ELSE 0 END)+SUM(CASE WHEN a.activity_type = 'open' THEN a.time_spent ELSE 0 END)))*100,2) AS send_perc,
 ROUND((SUM(CASE WHEN a.activity_type = 'open' THEN a.time_spent ELSE 0 END)/
 (SUM(CASE WHEN a.activity_type = 'send' THEN a.time_spent ELSE 0 END)+SUM(CASE WHEN a.activity_type = 'open' THEN a.time_spent ELSE 0 END)))*100,2) AS open_perc
FROM activities a
JOIN age_breakdown ab ON ab.user_id =  a.user_id
GROUP BY ab.age_bucket

--- example 4
SELECT customer_id
FROM customer_contracts c
JOIN products p ON p.product_id = c.product_id
WHERE LEFT(product_name,5) = 'Azure'
GROUP BY customer_id
HAVING COUNT(customer_id) > 2

---example 5
SELECT e.employee_id, 
e.name, 
COUNT(r.reports_to) reports_count, 
ROUND(AVG(r.age)) average_age
FROM Employees e
LEFT JOIN Employees r ON e.employee_id = r.reports_to

---example 6
SELECT product_name,
SUM(unit) unit 
FROM Products p
JOIN Orders o ON p.product_id = o.product_id 
WHERE EXTRACT(month FROM order_date) = 2
AND EXTRACT(year FROM order_date) = 2020
GROUP BY product_name  
HAVING SUM(unit) >= 100

---example 7
SELECT p.page_id
FROM pages p
LEFT JOIN page_likes l ON p.page_id = l.page_id
WHERE l.page_id IS NULL


---MID-course-test
---Q1
SELECT DISTINCT replacement_cost 
FROM film
ORDER BY replacement_cost 

---Q2
SELECT
CASE 
   WHEN replacement_cost BETWEEN 9.99 AND 19.99 THEN 'low'
   WHEN replacement_cost BETWEEN 20.00 AND 24.99 THEN 'medium'
   ELSE 'high'
END catergory,
COUNT(*) total
FROM film
GROUP BY catergory

---Q3
SELECT f.title, f.length, c.name category
FROM film f
JOIN film_category fc ON f.film_id =fc.film_id
JOIN category c ON fc.category_id = c.category_id
WHERE c.name IN ('Drama','Sports')
ORDER BY f.length DESC

---Q4
SELECT c.name category, 
COUNT(*) number_title
FROM film f
JOIN film_category fc ON f.film_id =fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY COUNT(*) DESC

---Q5
SELECT
CONCAT(a.first_name,' ', a.last_name) actor_name,
COUNT(*) number_film
FROM actor a
JOIN film_actor f ON a.actor_id = f.actor_id
GROUP BY actor_name
ORDER BY number_film DESC

---Q6
SELECT a.address_id, a.address
FROM address a
LEFT JOIN customer c ON a.address_id = c.address_id
WHERE c.customer_id IS NULL

---Q7
SELECT c.city,
SUM(amount) revenue
FROM city c
JOIN address a ON c.city_id = a.city_id
JOIN customer u ON u.address_id = a.address_id
JOIN payment p ON u.customer_id = p.customer_id
GROUP BY c.city
ORDER BY revenue DESC

---Q8
SELECT CONCAT(c.city, ', ', o.country) city_country,
SUM(p.amount) revenue
FROM city c
JOIN country o ON o.country_id = c.country_id
JOIN address a ON c.city_id = a.city_id
JOIN customer u ON u.address_id = a.address_id
JOIN payment p ON u.customer_id = p.customer_id
GROUP BY city_country
ORDER BY revenue DESC



