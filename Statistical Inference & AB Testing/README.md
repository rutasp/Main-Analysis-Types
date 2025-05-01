# 📊 Fast Food Marketing Campaign – A/B Testing Analysis

This repository contains the final graded A/B testing project from a data analytics sprint focused on **statistical inference and experimentation**. The task involves analyzing a dataset from a fast food chain's marketing campaigns to determine which of three promotional strategies performs best in increasing store sales.

---

## 🎯 Goal of the A/B Test

The primary goal of this A/B test is to **identify which of the three marketing campaigns (Promotion 1, 2, or 3) is most effective at boosting store sales**. Using historical weekly sales data aggregated by `location_id` and `promotion_id`, we aim to compare the sales performance of each campaign and recommend the best-performing promotion for wider rollout.

---

## 📏 Target Metric

The target metric for this test is:

- **Total sales in thousands of dollars**  
This metric provides a clear and interpretable measure of campaign effectiveness in terms of revenue generation. By aggregating the data at the `location_id` and `promotion` level, we ensure comparability between groups.

---

## 🛠️ SQL Queries for Data Preparation

### Step 1: Aggregate Sales by Location and Promotion

To evaluate campaign performance, the sales data was aggregated at the store (location) level per promotion:

```sql
WITH aggregated_sales AS (
  SELECT 
    location_id,
    promotion,
    AVG(sales_in_thousands) AS avg_sales,
    SUM(sales_in_thousands) AS total_sales,
    COUNT(week) AS num_weeks
  FROM `turing_data_analytics.wa_marketing_campaign`
  GROUP BY location_id, promotion
)
SELECT * FROM aggregated_sales;
