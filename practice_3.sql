--- example 1
SELECT 
Name
FROM STUDENTS
WHERE Marks > 75
ORDER BY RIGHT(Name,3), ID

---example 2
SELECT user_id,
CONCAT(UPPER(LEFT(name,1)), LOWER(RIGHT(name, LENGTH(name)-1))) name
FROM Users
ORDER BY user_id

---example 3
SELECT manufacturer,
CONCAT('$', ROUND(SUM(total_sales) / 1000000), ' million') AS sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC, manufacturer

---example 4
SELECT EXTRACT(month FROM submit_date) mth,
product_id product,
ROUND(AVG(stars),2)
FROM reviews
GROUP BY EXTRACT(month FROM submit_date), product_id
ORDER BY mth, product;

--- example 5
SELECT
sender_id,
COUNT(message_id) message_count
FROM messages
WHERE EXTRACT(month FROM sent_date) = 8
AND EXTRACT(year FROM sent_date) = 2022
GROUP BY sender_id
ORDER BY message_count DESC
LIMIT 2

---example 6
SELECT 
tweet_id
FROM Tweets
WHERE LENGTH(content) > 15

---example 7
SELECT activity_date day,
COUNT(DISTINCT user_id) active_users
FROM Activity
WHERE activity_date BETWEEN '2019-06-28' AND '2019-07-27'
GROUP BY activity_date 

---example 8
SELECT COUNT(ID)  number_employee
FROM employees
WHERE  EXTRACT(month FROM joining_date) BETWEEN 1 and 7
AND EXTRACT(year FROM joining_date) = 2022;

---example 9
select first_name,
POSITION('a' IN first_name)
FROM worker
WHERE first_name = 'Amitah'

---example 10
SELECT SUBSTRING(title, LENGTH(winery)+2, 4) AS vintage_year 
FROM winemag_p2
WHERE country = 'Macedonia'
