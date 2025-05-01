# 💰 Customer Lifetime Value (CLV) Cohort Analysis

This project focuses on building a **refined Customer Lifetime Value (CLV)** analysis using a cohort-based approach. Unlike traditional methods (e.g., Shopify's simplified CLV formula), this approach tracks **user spending behavior over time** for cohorts based on the first event week, including **all visitors** — not just purchasers.

## 🎯 Objective

To calculate weekly and cumulative CLV for all website users (not just buyers), using a **12-week cohort analysis** model and forecasting future revenue based on historical growth patterns. This model provides a more realistic and actionable understanding of customer value.

![image](https://github.com/user-attachments/assets/143cbd50-9c10-41ef-a8e2-b4ff37fa95c1)


## 🛠️ Tools & Technologies

- **SQL (BigQuery)** – for cohort creation and revenue aggregation  
- **Google Sheets / Excel** – for visualization, formatting, and forecasting  
- **Conditional Formatting & Charts** – for clearer analysis and insight discovery

## 📊 Methodology

### 1. Registration Cohort Identification
- Extracted each user’s **first event week** (`registration_week`) using `user_pseudo_id` and `event_timestamp`
- All users who visited the site are included, not just those who made a purchase

### 2. Weekly Revenue Aggregation
- Collected weekly revenue per user
- Joined this data to registration cohorts
- Standardized date formats for weekly alignment

### 3. Cohort-Based CLV Table
- Calculated **weekly Average Revenue Per User (ARPU)** by dividing revenue by the number of users in each cohort
- Resulted in a matrix: cohorts in rows, weeks (wk0–wk11) in columns

### 4. Cumulative CLV Table
- Built cumulative ARPU by summing week-over-week revenue per cohort
- Added:
  - **Cumulative Column Average**: average ARPU per week across cohorts
  - **Cumulative Growth %**: week-over-week revenue growth rate

### 5. Forecasting Future CLV
- For newer cohorts with limited observed weeks, predicted **future cumulative revenue** using average historical growth percentages
- Enabled estimation of full 12-week CLV even when complete data was unavailable

## 📈 Final Outputs

Three core cohort analysis tables were built:

1. **Weekly ARPU Table** – Shows average revenue per user over 12 weeks per cohort
2. **Cumulative ARPU Table** – Running total revenue per cohort per week
3. **Forecast Table** – Projects future revenue for incomplete cohorts using average cumulative growth %

All outputs include clear **conditional formatting** for visual clarity.

## 🔍 Key Insights

- Revenue growth slows significantly after the first few weeks  
- Some cohorts perform substantially better, possibly indicating seasonal or campaign effects  
- Including non-purchasing users gives a more **realistic average CLV**, often much lower than using buyer-only data

## ✅ Evaluation Criteria Met

- SQL used to calculate user counts, revenue, and order data by cohort  
- Correct cohort tracking and ARPU logic over 12 weeks  
- Well-structured cohort tables with cumulative sums and growth metrics  
- Forecasting approach clearly documented and applied  
- Insights drawn from cohort trends and supported with formatted charts

## ❓ Sample Review Questions

- Why is it important to include all users, not just purchasers, in CLV?  
- How does the cohort-based model improve over the Shopify formula?  
- How does cumulative growth % inform our revenue forecasts?  
- What limitations does this model have in predicting long-term customer value?  
- How would your CLV change if you account for a 10% Take Rate or compare it to CAC?

---

This analysis empowers decision-makers with a clearer, data-driven view of customer value over time, including how it evolves and what to expect from newer cohorts.
