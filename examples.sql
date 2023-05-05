

#1. Count the user activation Rate

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

