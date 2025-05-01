# 📊 Weekly Cohort Retention Analysis

This project focuses on analyzing subscription churn by calculating **weekly retention rates** instead of monthly, allowing for earlier detection of user drop-off trends.

## 📌 Objective

The goal is to track how many users remain active in the 6 weeks following their subscription start. Users are grouped into **weekly cohorts** based on their subscription start date from the `turing_data_analytics.subscriptions` table in BigQuery.

## 🛠️ Tools & Technologies

- **SQL (BigQuery)** – for cohort extraction and weekly retention calculation  
- **Google Sheets / Tableau /** – for data visualization  
- **Heatmaps & Charts** – to communicate retention trends clearly

## 🧠 Methodology

1. **Understand the Data**  
   Analyze table structure, especially start/end dates and user identifiers.

2. **Calculate Weekly Retention**  
   - Start with a single cohort (e.g., 2021-01-04 to 2021-01-11)
   - Track activity over the next 6 weeks
   - Use date truncation to group by week

3. **Expand to All Cohorts**  
   - Use conditional aggregation to calculate retention across cohorts
   - Capture weekly active users from Week 0 to Week 6

4. **Export & Visualize**  
   - Export results to Google Sheets or Tableau
   - Create a heatmap with retention rates
   - Add supporting line/bar charts for additional insights

5. **Interpret Trends**  
   - Identify patterns in drop-offs or spikes
   - Highlight high-performing cohorts
   - Provide actionable recommendations

## 📈 Output Example

- Heatmap: Weekly retention % by cohort
- Line Chart: Retention trend across weeks
- KPIs: Avg. retention rate, best/worst performing cohort

## ✅ Key Takeaways

- Weekly retention reveals trends missed by monthly analysis
- Enables faster response to churn issues
- Clear, visual insights for product teams and stakeholders

## 📝 Evaluation Criteria

- ✅ Correct SQL logic and formatting  
- ✅ Insightful and clear visualizations  
- ✅ Strong understanding of retention/churn concepts  
- ✅ Actionable insights based on analysis

## ❓ Sample Review Questions

- What is the relationship between churn and retention rate?  
- What is negative churn?  
- How would you define user retention?  
- Why are retention cohorts useful?
