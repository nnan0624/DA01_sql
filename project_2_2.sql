---Q1
WITH Monthly_Revenue AS (
SELECT 
FORMAT_DATE('%Y-%m', DATE(created_at)) AS month,
SUM(sale_price) TPV,
LAG(SUM(sale_price)) OVER (ORDER BY 1) Prev_TPV,
(SUM(sale_price) - LAG(SUM(sale_price)) OVER (ORDER BY 1)) / LAG(SUM(sale_price)) OVER (ORDER BY 1) * 100 AS Revenue_growth
FROM bigquery-public-data.thelook_ecommerce.order_items
GROUP BY 1
ORDER BY 1)
, Monthly_Orders AS (
SELECT 
FORMAT_DATE('%Y-%m', DATE(created_at)) AS month,
COUNT(Order_ID) AS TPO,
LAG(COUNT(Order_ID)) OVER (ORDER BY 1) AS Prev_TPO,
(COUNT(Order_ID) - LAG(COUNT(Order_ID)) OVER (ORDER BY 1)) / LAG(COUNT(Order_ID)) OVER (ORDER BY 1) * 100 AS Order_growth
FROM bigquery-public-data.thelook_ecommerce.order_items
GROUP BY 1
ORDER BY 1)
, Monthly_Products AS (
SELECT 
    FORMAT_DATE('%Y-%m', DATE(o.created_at)) AS month,
    FORMAT_DATE('%Y', DATE(o.created_at)) AS year,
    p.category,
    SUM(p.cost) cost,
    SUM(oi.sale_price) TPV,
    SUM(oi.sale_price - p.cost) AS total_profit,
    SUM((oi.sale_price - p.cost) / p.cost) AS profit_to_cost_ratio
    FROM bigquery-public-data.thelook_ecommerce.orders o
    JOIN bigquery-public-data.thelook_ecommerce.order_items oi ON o.order_id = oi.order_id
    JOIN bigquery-public-data.thelook_ecommerce.products p ON oi.product_id = p.id
    GROUP BY 1, 2, 3
    ORDER BY 1
)
CREAT VIEW  vw_ecommerce_analyst AS
SELECT 
  p.month,
  p.year,
  p.category,
  p.cost AS total_cost,
  r.TPV,
  o.TPO,
  p.total_profit,
  p.profit_to_cost_ratio,
  r.Revenue_growth,
  o.Order_growth
FROM Monthly_Products p
JOIN Monthly_Revenue r ON p.Month = r.Month
JOIN Monthly_Orders o ON p.Month = o.Month
WHERE r.Prev_TPV IS NOT NULL
    AND o.Prev_TPO IS NOT NULL
ORDER BY p.Month

---Q2
WITH a AS
(SELECT user_id, amount,created_at, 
FORMAT_DATE('%Y-%m', first_purchase_date) AS cohort_month,
(EXTRACT(year FROM created_at) - EXTRACT(year FROM first_purchase_date))*12 + 
EXTRACT(month FROM created_at) - EXTRACT(month FROM first_purchase_date) + 1 AS index
FROM
(SELECT 
user_id,
ROUND(sale_price,2) AS amount,
MIN(created_at) OVER (PARTITION BY user_id) AS first_purchase_date,
created_at
FROM bigquery-public-data.thelook_ecommerce.order_items) AS b)
, cohort_data AS (
SELECT cohort_month,
index,
COUNT(DISTINCT user_id) AS user_count,
ROUND(SUM(amount),2) AS revenue
FROM a
GROUP BY cohort_month, index
ORDER BY index
)
, customer_cohort AS(
SELECT 
cohort_month,
SUM(CASE WHEN index=1 THEN user_count ELSE 0 END) AS m1
, SUM(CASE WHEN index=2 THEN user_count ELSE 0 END) AS m2
, SUM(CASE WHEN index=3 THEN user_count ELSE 0 END) AS m3
, SUM(CASE WHEN index=4 THEN user_count ELSE 0 END) AS m4
FROM cohort_data 
GROUP BY cohort_month
ORDER BY cohort_month)
SELECT 
cohort_month,
ROUND(100* m1/m1,2) || '%' AS m1
,ROUND(100* m2/m1,2) || '%' AS m2
,ROUND(100* m3/m1,2) || '%' AS m3
,ROUND(100* m4/m1,2) || '%' AS m4
FROM customer_cohort

