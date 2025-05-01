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
```
---

## Explanation:

```avg_sales```: Average weekly sales for each store under a specific promotion.

```total_sales```: Cumulative sales across all weeks for each store and promotion.

```num_weeks```: Duration in weeks each store participated in the promotion.

---

## 📐 Statistical Testing

### Step 2: T-Tests for Continuous Metric
To assess the effectiveness of each promotion, pairwise two-sample t-tests were performed:

Each pair of campaigns was compared using a 99% confidence level (α = 0.01) due to the multiple testing problem.
The tests were carried out using the Evan Miller A/B Test Calculator.
Hypotheses:

#### Test 1: Promotion 1 vs Promotion 2

H₀: No significant difference in mean sales

H₁: A significant difference exists

#### Test 2: Promotion 1 vs Promotion 3

H₀: No significant difference in mean sales

H₁: A significant difference exists

#### Test 3: Promotion 2 vs Promotion 3

H₀: No significant difference in mean sales

H₁: A significant difference exists

---

## 📊 Results

Comparison	p-value	Statistically Significant?	Interpretation

**Promotion 1 vs Promotion 2** 0.00128	✅ Yes (p < 0.01)	Promotion 1 leads to significantly higher sales

**Promotion 1 vs Promotion 3**	> 0.01	❌ No	No statistically significant difference

**Promotion 2 vs Promotion 3** ~0.01	⚠️ Borderline	Not significant, but close to threshold – further testing advised

## Conclusion: 
**Promotion 1** is the most effective campaign, with statistically higher sales compared to Promotion 2. No clear advantage was observed between Promotions 1 and 3 or 2 and 3.

---

## ✅ Recommendation

Based on statistical testing, Promotion 1 should be rolled out across all locations, as it produced significantly higher sales than Promotion 2 and showed no downside compared to Promotion 3. Although the difference between Promotion 2 and Promotion 3 was not statistically significant, the result was close to the 0.01 threshold, suggesting potential value in re-running the test with more data.

---

## Tools Used

Google BigQuery (SQL)

Evan Miller's A/B Test Calculator – t-test for continuous data

