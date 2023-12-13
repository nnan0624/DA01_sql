--- example 1
SELECT NAME FROM CITY
WHERE COUNTRYCODE = 'USA'
AND POPULATION > 120000
  
--- example 2
SELECT * FROM CITY
WHERE COUNTRYCODE = 'JPN'
  
--- example 3
SELECT CITY, STATE FROM STATION
  
--- example 4 
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE 'A%' 
OR CITY LIKE 'E%'
OR CITY LIKE 'I%'
OR CITY LIKE 'O%'
OR CITY LIKE'U%'
  
--- example 5 
SELECT DISTINCT CITY FROM STATION
WHERE CITY LIKE '%A' 
OR CITY LIKE '%E'
OR CITY LIKE '%I'
OR CITY LIKE '%O'
OR CITY LIKE'%U'
  
--- example 6 
SELECT DISTINCT CITY FROM STATION
WHERE CITY NOT LIKE 'A%'
AND CITY NOT LIKE 'E%'
AND CITY NOT LIKE 'I%'
AND CITY NOT LIKE 'O%'
AND CITY NOT LIKE 'U%'
  
--- example 7
SELECT name from employee
ORDER BY name
  
--- example 8
SELECT name FROM employee
WHERE salary > 2000
AND months < 10
  
--- example 9
SELECT product_id FROM products
WHERE low_fats = 'Y'
AND recyclable = 'Y'
  
--- example 10
SELECT name FROM customer
WHERE referee_id <> 2 
OR referee_id IS NULL
  
--- example 11
SELECT name, population, area FROM world
WHERE area > 3000000 
OR population > 25000000

--- example 12
SELECT DISTINCT author_id AS id FROM Views
WHERE author_id = viewer_id
ORDER BY id

--- example 13
SELECT part, assembly_step FROM parts_assembly
WHERE finish_date IS NULL

--- example 14
SELECT * FROM lyft_drivers
WHERE yearly_salary <= 30000
OR yearly_salary >= 70000

--- example 15
SELECT * FROM uber_advertising
WHERE money_spent > 100000
AND YEAR = 2019
