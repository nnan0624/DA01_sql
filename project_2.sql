---Q1
SELECT COUNT(DISTINCT user_id) AS total_user,
COUNTIF(status ='Complete') AS total_orders,
FORMAT_DATE('%Y-%m', DATE(created_at)) AS month_year 
FROM bigquery-public-data.thelook_ecommerce.orders
WHERE DATE(created_at) BETWEEN '2019-01-01' AND '2022-04-30'
GROUP BY 3
ORDER BY 3
  
Insight: Số users và số đơn hàng tăng dần theo thời gian

---Q2
WITH CTE AS (SELECT COUNT(DISTINCT user_id) AS distinct_users,
FORMAT_DATE('%Y-%m', DATE(created_at)) AS month_year,
SUM(sale_price) order_price,
COUNT(order_id) num_order
FROM bigquery-public-data.thelook_ecommerce.order_items
GROUP BY 2)

SELECT month_year,
distinct_users,
ROUND(order_price/num_order,2) AS average_order_value
FROM CTE
WHERE month_year BETWEEN '2019-01-01' AND '2022-04-30'
ORDER BY month_year
  
Insight: Số lượng user tăng theo thời gian nhưng giá trị trung bình thay đổi không đáng kể

---Q3
WITH YoungestCustomers AS (
SELECT
first_name,
last_name,
gender,
age,
'youngest' AS tag
FROM
bigquery-public-data.thelook_ecommerce.users
WHERE 
age IN (
SELECT
MIN(age) AS min_age
FROM
bigquery-public-data.thelook_ecommerce.users
WHERE
DATE(created_at) BETWEEN '2019-01-01' AND '2022-04-30'
GROUP BY gender
)
)
, OldestCustomers AS (
SELECT
first_name,
last_name,
gender,
age,
'oldest' AS tag
FROM
bigquery-public-data.thelook_ecommerce.users
WHERE
age IN (
SELECT
MAX(age) AS max_age
FROM
bigquery-public-data.thelook_ecommerce.users
WHERE
DATE(created_at) BETWEEN '2019-01-01' AND '2022-04-30' 
GROUP BY
gender
)
)
, CombinedResults AS ( 
SELECT
first_name,
last_name,
gender,
age,
tag
FROM
YoungestCustomers

UNION ALL

SELECT
first_name,
last_name,
gender,
age,
tag
FROM
OldestCustomers)

SELECT
tag,
MIN(age) AS min_age,
MAX(age) AS max_age,
COUNT(*) AS customer_count
FROM
CombinedResults
GROUP BY
tag

Insight: Trẻ nhất là 12 tuổi có 1704 khách hàng, lớn tuổi nhất là 70 tuổi có 1693 khách hàng


---Q4








