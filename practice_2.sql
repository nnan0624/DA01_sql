---example 1
SELECT DISTINCT CITY
FROM STATION
WHERE ID % 2 = 0

---example 2
SELECT 
COUNT(*) - COUNT(DISTINCT CITY) AS Difference
FROM STATION

---example 3
SELECT CEIL(AVG(salary) - AVG(REPLACE(salary, '0', '')))
FROM EMPLOYEES

---example 4
SELECT CEIL(AVG(salary) - AVG(REPLACE(SALARY, '0','')))
FROM EMPLOYEES

---example 5 
SELECT ROUND(CAST(SUM(item_count * order_occurrences)/ SUM(order_occurrences) AS DECIMAL), 1) AS mean
FROM items_per_order

---example 6
SELECT user_id,
DATE(MAX(post_date)) - DATE(MIN(post_date)) days_between
FROM posts
WHERE post_date BETWEEN '01/01/2021' AND '12/31/2021'
GROUP BY user_id
HAVING COUNT(post_id) >= 2

---example 7
SELECT card_name,
MAX(issued_amount) - MIN(issued_amount) difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC

---example 8
SELECT manufacturer,
COUNT(drug) drug_count,
ABS(SUM(cogs-total_sales)) total_loss
FROM pharmacy_sales
WHERE total_sales < cogs
GROUP BY manufacturer
ORDER BY total_loss DESC

---example 9
SELECT * FROM Cinema
WHERE (id%2) != 0
AND description != 'boring'
ORDER BY rating DESC

---example 10
SELECT teacher_id,
COUNT(DISTINCT subject_id) cnt
FROM Teacher
GROUP BY teacher_id

---exmaple 11
SELECT user_id,
COUNT(DISTINCT follower_id) followers_count
FROM Followers
GROUP BY user_id

---example 12
SELECT class 
FROM Courses
GROUP BY class 
HAVING COUNT(class) > 5
