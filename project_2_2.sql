WITH Monthly_Revenue AS (
SELECT 
FORMAT_DATE('%Y-%m', DATE(created_at)) AS month,
SUM(sale_price) TPV,
LAG(SUM(sale_price)) OVER (ORDER BY 1) Prev_TPV
FROM bigquery-public-data.thelook_ecommerce.order_items
GROUP BY 1
ORDER BY 1)
, Monthly_Orders AS (
SELECT 
FORMAT_DATE('%Y-%m', DATE(created_at)) AS month,
COUNT(Order_ID) AS TPO,
LAG(COUNT(Order_ID)) OVER (ORDER BY 1) Prev_TPO
FROM bigquery-public-data.thelook_ecommerce.order_items
GROUP BY 1
ORDER BY 1)
, Monthly_Products AS (
SELECT 
    FORMAT_DATE('%Y-%m', DATE(o.created_at)) AS month,
    FORMAT_DATE('%Y', DATE(o.created_at)) AS year,
    p.category,
    SUM(p.cost) cost
    FROM bigquery-public-data.thelook_ecommerce.orders o
    JOIN bigquery-public-data.thelook_ecommerce.order_items oi ON o.order_id = oi.order_id
    JOIN bigquery-public-data.thelook_ecommerce.products p ON oi.product_id = p.id
    GROUP BY 1, 2, 3
    ORDER BY 1
)
SELECT 
  p.month,
  p.year,
  SUM(p.cost) AS total_cost,
  SUM(r.TPV) AS TPV,
  SUM(r.TPV - p.cost) AS total_profit,
  SUM((r.TPV - p.cost) / p.cost) AS profit_to_cost_ratio,
  (SUM(r.TPV) - LAG(SUM(r.TPV)) OVER (ORDER BY p.Month)) / LAG(SUM(r.TPV)) OVER (ORDER BY p.Month) * 100 AS Revenue_growth,
  (SUM(o.TPO) - LAG(SUM(o.TPO)) OVER (ORDER BY p.Month)) / LAG(SUM(o.TPO)) OVER (ORDER BY p.Month) * 100 AS Order_growth
FROM Monthly_Products p
JOIN Monthly_Revenue r ON p.Month = r.Month
JOIN Monthly_Orders o ON p.Month = o.Month
WHERE r.Prev_TPV IS NOT NULL
    AND o.Prev_TPO IS NOT NULL
GROUP BY p.Month, p.year
ORDER BY p.Month
