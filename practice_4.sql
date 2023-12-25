---example 1
SELECT 
SUM(CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 END) AS laptop_views, 
SUM(CASE WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0 END) AS mobile_views 
FROM viewership

---example 2
SELECT
x,y,z,
CASE 
WHEN (x+y) > z  
AND (x+z) > y
AND (y+z) > x
THEN 'Yes' ELSE 'No' 
END AS triangle
FROM Triangle

---example 3
SELECT
ROUND((SUM(CASE WHEN call_category IS NULL OR call_category = 'n/a' THEN 1 ELSE 0 END) / COUNT(*)) * 100.0, 1) AS call_percentage
FROM
    callers

---example 4
SELECT name FROM customer
WHERE referee_id <> 2 
OR referee_id IS NULL

---example 5
SELECT
survived,
SUM(CASE WHEN pclass = 1 THEN 1 ELSE 0 END) AS first_class,
SUM(CASE WHEN pclass = 2 THEN 1 ELSE 0 END) AS second_class,
SUM(CASE WHEN pclass = 3 THEN 1 ELSE 0 END) AS third_class
FROM titanic
GROUP BY survived
