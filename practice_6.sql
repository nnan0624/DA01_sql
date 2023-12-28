---ex1 
WITH job_count_CTE AS (SELECT 
company_id, 
title, 
description,
COUNT(job_id) job_count
FROM job_listings
GROUP BY company_id, title, description)
SELECT COUNT(DISTINCT company_id) duplicate_companies FROM job_count_CTE
WHERE job_count >1

---ex2
WITH cate_CTE AS (SELECT 
  category, 
  product, 
  SUM(spend) AS total_spend,
  RANK() OVER (
      PARTITION BY category 
      ORDER BY SUM(spend) DESC) AS ranking
FROM product_spend 
WHERE EXTRACT(year FROM transaction_date) = 2022
GROUP BY category, product)
SELECT category, product, total_spend FROM cate_CTE
WHERE ranking <= 2 
ORDER BY category, ranking

---ex3
WITH cte_a AS (SELECT policy_holder_id, count(case_id)
FROM callers
GROUP BY policy_holder_id
HAVING count(case_id)>=3)
SELECT COUNT(policy_holder_id) FROM cte_a
  
---ex4
SELECT p.page_id
FROM pages p
LEFT JOIN page_likes l ON p.page_id = l.page_id
WHERE l.page_id IS NULL

---ex5
WITH cte AS
(SELECT  user_id	
FROM user_actions 
WHERE EXTRACT(month FROM event_date) in (6,7) 
AND EXTRACT(year FROM event_date) = 2022
GROUP BY user_id HAVING count(DISTINCT EXTRACT(month FROM event_date)) = 2)
SELECT 7 AS month, count(*) AS monthly_active_users 
FROM cte 

---ex6
SELECT
  DATE_FORMAT(trans_date, '%Y-%m') AS month,
   country,
   SUM(amount)  trans_total_amount,
   COUNT(*) trans_count,
   SUM(CASE WHEN state  = 'approved' THEN amount ELSE 0 END) approved_total_amount,
   SUM(CASE WHEN state  = 'approved' THEN 1 ELSE 0 END) approved_count 
FROM Transactions
GROUP BY DATE_FORMAT(trans_date, '%Y-%m'), country

---ex7
WITH ranked_CTE AS (SELECT product_id, 
 year, 
 quantity, 
 price,
 RANK() OVER (PARTITION BY product_id ORDER BY year) AS sale_rank
FROM Sales )
SELECT product_id, 
  year AS first_year, 
  quantity, 
  price 
FROM ranked_CTE
WHERE sale_rank = 1

---ex8
SELECT customer_id FROM Customer c
JOIN Product p ON c.product_key = p.product_key
GROUP BY customer_id
HAVING COUNT(*) = 2

---ex9
SELECT employee_id
FROM employees
WHERE salary < 30000
AND manager_id  NOT IN (SELECT employee_id FROM employees) 

---ex10
SELECT e.employee_id , e.department_id 
FROM employee e 
WHERE e.primary_flag='Y' 
OR e.employee_id IN (SELECT employee_id 
FROM employee 
GROUP BY employee_id 
HAVING count(distinct department_id)=1)

---ex11
















