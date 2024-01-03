---ex1
WITH yearly_spend_cte AS (
  SELECT 
    EXTRACT(YEAR FROM transaction_date) AS yr,
    product_id,
    spend AS curr_year_spend,
    LAG(spend) OVER (
      PARTITION BY product_id 
      ORDER BY 
        product_id, 
        EXTRACT(YEAR FROM transaction_date)) AS prev_year_spend 
  FROM user_transactions
)

SELECT 
  yr,
  product_id, 
  curr_year_spend, 
  prev_year_spend, 
  ROUND(100 * 
    (curr_year_spend - prev_year_spend)
    / prev_year_spend
  , 2) AS yoy_rate 
FROM yearly_spend_cte

---ex2
WITH card_lauch AS(SELECT 
card_name,
issued_amount,
MAKE_DATE(issue_year, issue_month, 1) AS issued_day,
MIN(MAKE_DATE(issue_year, issue_month, 1)) OVER(PARTITION BY card_name) AS launch_date
FROM monthly_cards_issued)
SELECT
card_name,
issued_amount
FROM card_lauch
WHERE issued_day = launch_date
ORDER BY issued_amount DESC

---ex3
WITH third_transaction AS(
SELECT user_id, spend, transaction_date,
ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY transaction_date) AS row_num
FROM transactions
)
SELECT user_id, spend, transaction_date
FROM third_transaction
WHERE row_num=3

---ex4
WITH last_transaction AS(
SELECT transaction_date, user_id, product_id,
RANK() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) transaction_rank
FROM user_transactions)
SELECT transaction_date, user_id, COUNT(product_id)
FROM last_transaction 
WHERE transaction_rank =1
GROUP BY transaction_date, user_id
ORDER BY transaction_date

---ex5
SELECT user_id,
tweet_date,
ROUND(AVG(tweet_count) 
OVER(PARTITION BY user_id 
ORDER BY tweet_date 
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW),2) AS rolling_avg_3d
FROM tweets

---ex6
WITH diff_transaction AS(
SELECT 
  transaction_id
  merchant_id, 
  credit_card_id, 
  amount, 
  transaction_timestamp,
  EXTRACT(EPOCH FROM transaction_timestamp - LAG(transaction_timestamp) OVER (
    PARTITION BY merchant_id, credit_card_id, amount 
    ORDER BY transaction_timestamp)
  )/60 AS minute_difference 
FROM transactions
)
SELECT COUNT(merchant_id) AS payment_count 
FROM diff_transaction 
WHERE minute_difference <= 10

---ex7
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

---ex8
WITH cte AS(SELECT 
  a.artist_name,
  DENSE_RANK() OVER (ORDER BY COUNT(s.song_id) DESC) AS artist_rank
FROM artists a
JOIN songs s ON a.artist_id = s.artist_id
JOIN global_song_rank r ON s.song_id = r.song_id
WHERE r.rank <= 10
GROUP BY a.artist_name)
SELECT artist_name, artist_rank
FROM cte 
WHERE artist_rank <=5
