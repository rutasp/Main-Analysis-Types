-- RFM SCORE 

WITH Table1 AS (
-- Step 1: Calculate recency, frequency, and monetary value
SELECT 
CustomerID,
DATE_DIFF(DATE '2011-12-01', CAST(MAX(InvoiceDate) AS DATE), DAY) AS recency, -- Can be adjusted dynamically
COUNT(DISTINCT InvoiceNo) AS frequency,
SUM(UnitPrice * Quantity) AS monetary
FROM 
`tc-da-1.turing_data_analytics.rfm` 
WHERE 
InvoiceDate BETWEEN '2010-12-01' AND '2011-12-02' 
AND Quantity > 0 
AND UnitPrice > 0 
AND CustomerID IS NOT NULL 
GROUP BY 
CustomerID
),

Quantiles AS (
-- Step 2: Calculate quartiles for recency, frequency, and monetary values
SELECT 
APPROX_QUANTILES(recency, 4) AS recency_quantiles,
APPROX_QUANTILES(frequency, 4) AS frequency_quantiles,
APPROX_QUANTILES(monetary, 4) AS monetary_quantiles
FROM 
Table1
),

Table2 AS (
-- Step 3: Assign R, F, and M scores based on quartiles
SELECT 
t1.CustomerID,
t1.recency,
t1.frequency,
t1.monetary,
-- Assign R score (1-4) based on recency quartiles; note lower recency means higher score
CASE 
WHEN t1.recency <= (SELECT recency_quantiles[OFFSET(1)] FROM Quantiles) THEN 4
WHEN t1.recency <= (SELECT recency_quantiles[OFFSET(2)] FROM Quantiles) THEN 3
WHEN t1.recency <= (SELECT recency_quantiles[OFFSET(3)] FROM Quantiles) THEN 2
ELSE 1
END AS R_score,
-- Assign F score (1-4) based on frequency quartiles; higher frequency means higher score
CASE 
WHEN t1.frequency >= (SELECT frequency_quantiles[OFFSET(3)] FROM Quantiles) THEN 4
WHEN t1.frequency >= (SELECT frequency_quantiles[OFFSET(2)] FROM Quantiles) THEN 3
WHEN t1.frequency >= (SELECT frequency_quantiles[OFFSET(1)] FROM Quantiles) THEN 2
ELSE 1
END AS F_score,
-- Assign M score (1-4) based on monetary quartiles; higher monetary value means higher score
CASE 
WHEN t1.monetary >= (SELECT monetary_quantiles[OFFSET(3)] FROM Quantiles) THEN 4
WHEN t1.monetary >= (SELECT monetary_quantiles[OFFSET(2)] FROM Quantiles) THEN 3
WHEN t1.monetary >= (SELECT monetary_quantiles[OFFSET(1)] FROM Quantiles) THEN 2
ELSE 1
END AS M_score
FROM 
Table1 t1
),

Table3 AS (
-- Step 4: Calculate RFM score and count customers for each RFM score
SELECT 
CONCAT(CAST(R_score AS STRING), CAST(F_score AS STRING), CAST(M_score AS STRING)) AS RFM_score,
COUNT(*) AS CustomerCount
FROM 
Table2
GROUP BY 
RFM_score
)

-- Final selection
SELECT 
RFM_score,
CustomerCount
FROM 
Table3
ORDER BY 
CustomerCount


-- SEGMENTATION

WITH Table1 AS (
-- Step 1: Calculate recency, frequency, and monetary value
SELECT 
CustomerID,
DATE_DIFF(DATE '2011-12-01', CAST(MAX(InvoiceDate) AS DATE), DAY) AS recency, -- Can be adjusted dynamically
COUNT(DISTINCT InvoiceNo) AS frequency,
SUM(UnitPrice * Quantity) AS monetary
FROM 
`tc-da-1.turing_data_analytics.rfm` 
WHERE 
InvoiceDate BETWEEN '2010-12-01' AND '2011-12-02' 
AND Quantity > 0 
AND UnitPrice > 0 
AND CustomerID IS NOT NULL 
GROUP BY 
CustomerID
),

Quantiles AS (
-- Step 2: Calculate quartiles for recency, frequency, and monetary values
SELECT 
APPROX_QUANTILES(recency, 4) AS recency_quantiles,
APPROX_QUANTILES(frequency, 4) AS frequency_quantiles,
APPROX_QUANTILES(monetary, 4) AS monetary_quantiles
FROM 
Table1
),

Table2 AS (
-- Step 3: Assign R, F, and M scores based on quartiles
SELECT 
t1.CustomerID,
t1.recency,
t1.frequency,
t1.monetary,
-- Assign R score (1-4) based on recency quartiles; note lower recency means higher score
CASE 
WHEN t1.recency <= (SELECT recency_quantiles[OFFSET(1)] FROM Quantiles) THEN 4
WHEN t1.recency <= (SELECT recency_quantiles[OFFSET(2)] FROM Quantiles) THEN 3
WHEN t1.recency <= (SELECT recency_quantiles[OFFSET(3)] FROM Quantiles) THEN 2
ELSE 1
END AS R_score,
-- Assign F score (1-4) based on frequency quartiles; higher frequency means higher score
CASE 
WHEN t1.frequency >= (SELECT frequency_quantiles[OFFSET(3)] FROM Quantiles) THEN 4
WHEN t1.frequency >= (SELECT frequency_quantiles[OFFSET(2)] FROM Quantiles) THEN 3
WHEN t1.frequency >= (SELECT frequency_quantiles[OFFSET(1)] FROM Quantiles) THEN 2
ELSE 1
END AS F_score,
-- Assign M score (1-4) based on monetary quartiles; higher monetary value means higher score
CASE 
WHEN t1.monetary >= (SELECT monetary_quantiles[OFFSET(3)] FROM Quantiles) THEN 4
WHEN t1.monetary >= (SELECT monetary_quantiles[OFFSET(2)] FROM Quantiles) THEN 3
WHEN t1.monetary >= (SELECT monetary_quantiles[OFFSET(1)] FROM Quantiles) THEN 2
ELSE 1
END AS M_score
FROM 
Table1 t1
),

Table3 AS (
-- Step 4: Calculate RFM score and count customers for each RFM score
SELECT 
t2.CustomerID,
CONCAT(CAST(R_score AS STRING), CAST(F_score AS STRING), CAST(M_score AS STRING)) AS RFM_score,
R_score, F_score, M_score
FROM 
Table2 t2
),

Segments AS (
-- Step 5: Segment customers based on RFM scores
SELECT 
CustomerID,
RFM_score,
-- Assign customer segments based on R, F, and M scores
CASE 
-- Best Customers: High R, F, and M scores
WHEN R_score = 4 AND F_score = 4 AND M_score = 4 THEN 'Best Customers'
-- Loyal Customers: High F, varying R and M
WHEN F_score >= 3 AND R_score >= 3 THEN 'Loyal Customers'
-- Big Spenders: High M, varying R and F
WHEN M_score >= 3 THEN 'Big Spenders'
-- Lost Customers: Low R
WHEN R_score = 1 THEN 'Lost Customers'
-- Others: Catch-all for the remaining categories
ELSE 'Other Customers'
END AS CustomerSegment
FROM 
Table3
)

-- Final selection
SELECT 
CustomerSegment,
COUNT(*) AS TotalCustomers
FROM 
Segments
GROUP BY 
CustomerSegment
ORDER BY 
TotalCustomers DESC;

-- Weekly Average Revenue by Cohorts

WITH
-- Define the reference date for checking if a week has happened
reference_date AS (
SELECT DATE '2021-01-24' AS ref_date
),

UserActivity AS (
-- Step 1: Get all users, calculate total value if they made purchases, and find the first visit date
SELECT 
user_pseudo_id AS customer_id,
MIN(PARSE_DATE('%Y%m%d', event_date)) AS first_visit, -- Convert event_date from YYYYMMDD format to DATE
SUM(purchase_revenue_in_usd) AS total_customer_revenue
FROM 
`turing_data_analytics.raw_events`
GROUP BY 
user_pseudo_id
),

Cohorts AS (
-- Step 2: Assign users to their respective cohort week based on their first visit
SELECT 
customer_id,
-- Adjust cohort week to start on Sunday
DATE_TRUNC(first_visit, WEEK(SUNDAY)) AS cohort_week, -- Cohort week of the user's first visit starts on Sunday
total_customer_revenue
FROM 
UserActivity
),

RevenueByWeek AS (
-- Step 3: Distribute revenue across 13 weeks from the cohort start
SELECT 
c.cohort_week,
week_offset,
DATE_ADD(c.cohort_week, INTERVAL week_offset WEEK) AS week_start_date,
DATE_ADD(DATE_ADD(c.cohort_week, INTERVAL week_offset WEEK), INTERVAL 6 DAY) AS week_end_date, -- Define the end of the week as 6 days after the start
IFNULL(SUM(e.purchase_revenue_in_usd), NULL) AS revenue -- Sum revenue per cohort week and customer
FROM 
Cohorts c
CROSS JOIN UNNEST(GENERATE_ARRAY(0, 12)) AS week_offset -- Create 13 weeks range (wk0 to wk12)
LEFT JOIN `turing_data_analytics.raw_events` e
ON c.customer_id = e.user_pseudo_id
AND PARSE_DATE('%Y%m%d', e.event_date) BETWEEN DATE_ADD(c.cohort_week, INTERVAL week_offset WEEK) 
AND DATE_ADD(DATE_ADD(c.cohort_week, INTERVAL week_offset WEEK), INTERVAL 6 DAY) -- Match events within each weekly interval
GROUP BY 
c.cohort_week, week_offset
),

-- Filter out weeks that have not yet happened relative to the reference date
filtered_revenue AS (
SELECT 
r.cohort_week,
r.week_start_date,
r.week_end_date,
r.revenue
FROM 
RevenueByWeek r
JOIN reference_date ref
ON r.week_start_date <= ref.ref_date -- Ensure only past weeks are included
),

-- Count the number of registrations per cohort week and week offset
UserRegistrationsByWeek AS (
SELECT 
c.cohort_week,
week_offset,
COUNT(DISTINCT c.customer_id) AS registrations
FROM 
Cohorts c
CROSS JOIN UNNEST(GENERATE_ARRAY(0, 12)) AS week_offset
GROUP BY 
c.cohort_week, week_offset
),

-- Calculate revenue per registration for each cohort week and offset
RevenuePerRegistration AS (
SELECT 
r.cohort_week,
r.week_start_date,
r.revenue / COALESCE(ur.registrations, 1) AS revenue_per_registration
FROM 
RevenueByWeek r
LEFT JOIN 
UserRegistrationsByWeek ur
ON 
r.cohort_week = ur.cohort_week 
AND DATE_DIFF(r.week_start_date, r.cohort_week, WEEK) = ur.week_offset
),

-- Pivot revenue per registration into separate columns
WeeklyRevenuePerRegistrationPivot AS (
SELECT 
cohort_week,
MAX(CASE WHEN DATE_DIFF(week_start_date, cohort_week, WEEK) = 0 THEN NULLIF(revenue_per_registration, 0) ELSE NULL END) AS wk0,
MAX(CASE WHEN DATE_DIFF(week_start_date, cohort_week, WEEK) = 1 THEN NULLIF(revenue_per_registration, 0) ELSE NULL END) AS wk1,
MAX(CASE WHEN DATE_DIFF(week_start_date, cohort_week, WEEK) = 2 THEN NULLIF(revenue_per_registration, 0) ELSE NULL END) AS wk2,
MAX(CASE WHEN DATE_DIFF(week_start_date, cohort_week, WEEK) = 3 THEN NULLIF(revenue_per_registration, 0) ELSE NULL END) AS wk3,
MAX(CASE WHEN DATE_DIFF(week_start_date, cohort_week, WEEK) = 4 THEN NULLIF(revenue_per_registration, 0) ELSE NULL END) AS wk4,
MAX(CASE WHEN DATE_DIFF(week_start_date, cohort_week, WEEK) = 5 THEN NULLIF(revenue_per_registration, 0) ELSE NULL END) AS wk5,
MAX(CASE WHEN DATE_DIFF(week_start_date, cohort_week, WEEK) = 6 THEN NULLIF(revenue_per_registration, 0) ELSE NULL END) AS wk6,
MAX(CASE WHEN DATE_DIFF(week_start_date, cohort_week, WEEK) = 7 THEN NULLIF(revenue_per_registration, 0) ELSE NULL END) AS wk7,
MAX(CASE WHEN DATE_DIFF(week_start_date, cohort_week, WEEK) = 8 THEN NULLIF(revenue_per_registration, 0) ELSE NULL END) AS wk8,
MAX(CASE WHEN DATE_DIFF(week_start_date, cohort_week, WEEK) = 9 THEN NULLIF(revenue_per_registration, 0) ELSE NULL END) AS wk9,
MAX(CASE WHEN DATE_DIFF(week_start_date, cohort_week, WEEK) = 10 THEN NULLIF(revenue_per_registration, 0) ELSE NULL END) AS wk10,
MAX(CASE WHEN DATE_DIFF(week_start_date, cohort_week, WEEK) = 11 THEN NULLIF(revenue_per_registration, 0) ELSE NULL END) AS wk11,
MAX(CASE WHEN DATE_DIFF(week_start_date, cohort_week, WEEK) = 12 THEN NULLIF(revenue_per_registration, 0) ELSE NULL END) AS wk12
FROM 
RevenuePerRegistration
GROUP BY 
cohort_week
ORDER BY 
cohort_week
)

-- Final Output: Display the cohort distribution with revenue per registration for each week offset (wk0 to wk12)
SELECT 
cohort_week AS week_start_date,
wk0,
wk1,
wk2,
wk3,
wk4,
wk5,
wk6,
wk7,
wk8,
wk9,
wk10,
wk11,
wk12
FROM 
WeeklyRevenuePerRegistrationPivot
WHERE 
cohort_week <= DATE '2021-01-24'
ORDER BY 
cohort_week;
