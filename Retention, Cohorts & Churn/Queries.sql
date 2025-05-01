WITH week0_subscriptions AS (
-- Number of subscriptions that started in each week (wk0)
SELECT 
DATE_TRUNC(subscription_start, WEEK) AS week_start_date,
COUNT(user_pseudo_id) AS count_wk0
FROM 
turing_data_analytics.subscriptions
GROUP BY 
week_start_date
),
-- Calculate the number of subscriptions still active in week 1
week1_subscriptions AS (
SELECT 
DATE_TRUNC(subscription_start, WEEK) AS week_start_date,
COUNT(user_pseudo_id) AS count_wk1
FROM 
turing_data_analytics.subscriptions
WHERE 
(subscription_end IS NULL 
OR subscription_end > DATE_TRUNC(subscription_start, WEEK) + INTERVAL 7 DAY)
GROUP BY 
week_start_date
),

week2_subscriptions AS (
SELECT 
DATE_TRUNC(subscription_start, WEEK) AS week_start_date,
COUNT(user_pseudo_id) AS count_wk2
FROM 
turing_data_analytics.subscriptions
WHERE 
(subscription_end IS NULL 
OR subscription_end > DATE_TRUNC(subscription_start, WEEK) + INTERVAL 14 DAY)
GROUP BY 
week_start_date
),

week3_subscriptions AS (
SELECT 
DATE_TRUNC(subscription_start, WEEK) AS week_start_date,
COUNT(user_pseudo_id) AS count_wk3
FROM 
turing_data_analytics.subscriptions
WHERE 
(subscription_end IS NULL 
OR subscription_end > DATE_TRUNC(subscription_start, WEEK) + INTERVAL 21 DAY)
GROUP BY 
week_start_date
),

week4_subscriptions AS (
SELECT 
DATE_TRUNC(subscription_start, WEEK) AS week_start_date,
COUNT(user_pseudo_id) AS count_wk4
FROM 
turing_data_analytics.subscriptions
WHERE 
(subscription_end IS NULL 
OR subscription_end > DATE_TRUNC(subscription_start, WEEK) + INTERVAL 28 DAY)
GROUP BY 
week_start_date
),

week5_subscriptions AS (
SELECT 
DATE_TRUNC(subscription_start, WEEK) AS week_start_date,
COUNT(user_pseudo_id) AS count_wk5
FROM 
turing_data_analytics.subscriptions
WHERE 
(subscription_end IS NULL OR subscription_end > DATE_TRUNC(subscription_start, WEEK) + INTERVAL 35 DAY)
GROUP BY 
week_start_date
),

week6_subscriptions AS (
SELECT 
DATE_TRUNC(subscription_start, WEEK) AS week_start_date,
COUNT(user_pseudo_id) AS count_wk6
FROM 
turing_data_analytics.subscriptions
WHERE 
(subscription_end IS NULL OR subscription_end > DATE_TRUNC(subscription_start, WEEK) + INTERVAL 42 DAY)
GROUP BY 
week_start_date
)


SELECT 
w0.week_start_date,
w0.count_wk0 AS active_wk0,
COALESCE(w1.count_wk1, 0) AS active_wk1,
COALESCE(w2.count_wk2, 0) AS active_wk2,
COALESCE(w3.count_wk3, 0) AS active_wk3,
COALESCE(w4.count_wk4, 0) AS active_wk4,
COALESCE(w5.count_wk5, 0) AS active_wk5,
COALESCE(w6.count_wk6, 0) AS active_wk6
FROM 
week0_subscriptions w0
LEFT JOIN 
week1_subscriptions w1 ON w0.week_start_date = w1.week_start_date
LEFT JOIN 
week2_subscriptions w2 ON w0.week_start_date = w2.week_start_date
LEFT JOIN 
week3_subscriptions w3 ON w0.week_start_date = w3.week_start_date
LEFT JOIN 
week4_subscriptions w4 ON w0.week_start_date = w4.week_start_date
LEFT JOIN 
week5_subscriptions w5 ON w0.week_start_date = w5.week_start_date
LEFT JOIN 
week6_subscriptions w6 ON w0.week_start_date = w6.week_start_date
ORDER BY 
w0.week_start_date;
