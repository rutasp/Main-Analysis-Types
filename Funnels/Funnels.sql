-- Clean data
WITH AggregatedEvents AS (
SELECT 
user_pseudo_id,
event_name,
MIN(event_timestamp) AS first_event_timestamp
FROM `turing_data_analytics.raw_events`
GROUP BY event_name, user_pseudo_id
)
SELECT 
raw_events.*
FROM 
`turing_data_analytics.raw_events` raw_events
JOIN 
AggregatedEvents agg 
ON raw_events.user_pseudo_id = agg.user_pseudo_id 
AND raw_events.event_name = agg.event_name 
AND raw_events.event_timestamp = agg.first_event_timestamp
ORDER BY 
raw_events.event_timestamp;



-- Find events for funnel analysis
WITH AggregatedEvents AS (
SELECT 
user_pseudo_id,
event_name,
MIN(event_timestamp) AS first_event_timestamp
FROM 
`turing_data_analytics.raw_events`
GROUP BY 
event_name, user_pseudo_id
)
SELECT 
raw_events.event_name, 
COUNT(*) AS event_count -- Count the occurrences of each event_name
FROM 
`turing_data_analytics.raw_events` raw_events
JOIN 
AggregatedEvents agg 
ON 
raw_events.user_pseudo_id = agg.user_pseudo_id 
AND raw_events.event_name = agg.event_name 
AND raw_events.event_timestamp = agg.first_event_timestamp
GROUP BY 
raw_events.event_name -- Group by event_name to aggregate counts
ORDER BY 
event_count DESC; 


-- Find top 3 countries
WITH AggregatedEvents AS (
SELECT 
user_pseudo_id,
event_name,
MIN(event_timestamp) AS first_event_timestamp
FROM 
`turing_data_analytics.raw_events`
GROUP BY 
event_name, user_pseudo_id
)
SELECT 
raw_events.country, -- Select the country column
COUNT(*) AS event_count -- Count the number of events per country
FROM 
`turing_data_analytics.raw_events` raw_events
JOIN 
AggregatedEvents agg 
ON 
raw_events.user_pseudo_id = agg.user_pseudo_id 
AND raw_events.event_name = agg.event_name 
AND raw_events.event_timestamp = agg.first_event_timestamp
GROUP BY 
raw_events.country -- Group by country to aggregate counts
ORDER BY 
event_count DESC 
LIMIT 3;

-- Find aggregated and top3 countries selected funnels
WITH AggregatedEvents AS (
SELECT 
user_pseudo_id,
event_name,
MIN(event_timestamp) AS first_event_timestamp
FROM 
`turing_data_analytics.raw_events`
WHERE 
event_name IN ('session_start', 'scroll', 'view_item', 'add_to_cart', 'add_payment_info', 'purchase')
GROUP BY 
event_name, user_pseudo_id
)
SELECT 
raw_events.event_name, 
COUNT(*) AS event_count, -- Count the total occurrences of each event_name
SUM(CASE WHEN raw_events.country = 'United States' THEN 1 ELSE 0 END) AS US_count, 
SUM(CASE WHEN raw_events.country = 'India' THEN 1 ELSE 0 END) AS India_count, 
SUM(CASE WHEN raw_events.country = 'Canada' THEN 1 ELSE 0 END) AS Canada_count 
FROM 
`turing_data_analytics.raw_events` raw_events
JOIN 
AggregatedEvents agg 
ON 
raw_events.user_pseudo_id = agg.user_pseudo_id 
AND raw_events.event_name = agg.event_name 
AND raw_events.event_timestamp = agg.first_event_timestamp
WHERE
raw_events.event_name IN ('session_start', 'scroll', 'view_item', 'add_to_cart', 'add_payment_info', 'purchase')
GROUP BY 
raw_events.event_name 
ORDER BY 
event_count DESC; 
