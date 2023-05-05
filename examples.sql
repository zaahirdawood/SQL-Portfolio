-- Translating business questionsn to SQL Syntax

--1. Count the user activation Rate
-- Postgres 14 Syntax 

WITH CTE AS (
    SELECT 
      COUNT(user_id) FILTER(WHERE signup_action = 'Confirmed') AS count_confirmed,
      COUNT(user_id) FILTER(WHERE signup_action = 'Not Confirmed') AS count_not_confirmed
    FROM emails as e
    LEFT JOIN texts as t
        ON e.email_id = t.email_id
            )
SELECT ROUND((count_confirmed / SUM(count_confirmed + count_not_confirmed)),2) AS confirm_rate
FROM CTE
GROUP BY count_confirmed,count_not_confirmed

--2. How well do credit cards typically do first month of launch (question derived by a companies need to launch a new credit card)
    -- we are analysing the number of requested credit cards upon first month the cards were launched.

WITH CTE AS (
      SELECT 
      card_name, 
      issued_amount,
      MAKE_DATE(issue_year,issue_month,1) as issue_date, 
      MIN(MAKE_DATE(issue_year,issue_month,1)) OVER(PARTITION BY card_name) min_issue_date
      FROM monthly_cards_issued
      ORDER BY issued_amount DESC
            )

SELECT card_name, issued_amount
FROM CTE
WHERE issue_date = min_issue_date
ORDER BY issued_amount DESC
