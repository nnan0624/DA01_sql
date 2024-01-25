WITH growth AS (SELECT 
SUM(oi.sale_price) TPV,
COUNT(*) AS TPO,
FORMAT_DATE('%Y-%m', DATE(o.created_at)) AS month,
product_id
FROM bigquery-public-data.thelook_ecommerce.orders o
JOIN bigquery-public-data.thelook_ecommerce.order_items oi ON o.order_id = oi.order_id
GROUP BY 3,4
ORDER BY 3,4
)

SELECT 
category,
(TPV - LAG(TPV, 1) OVER (PARTITION BY category ORDER BY month) / LAG(TPV, 1) OVER (PARTITION BY category ORDER BY month)) AS Revenue_growth,
(TPO - LAG(TPO, 1) OVER (PARTITION BY category ORDER BY month) / LAG(TPO, 1) OVER (PARTITION BY category ORDER BY month)) AS Order_growth
FROM growth g
JOIN
  bigquery-public-data.thelook_ecommerce.products p ON g.product_id = p.id
