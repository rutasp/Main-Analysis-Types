# 🔻 Website Funnel Analysis by Country

This project focuses on building a **sales funnel chart** from website event data stored in the `raw_events` table. The goal is to analyze user behavior from visit to conversion, identifying drop-offs across key stages of the funnel and how these vary by country.

## 🎯 Objective

To extract and visualize a clear, de-duplicated funnel from raw user events, comparing conversion performance across the **top 3 countries** by event volume. This will help surface actionable insights into user behavior and potential UX or performance issues.

## 🛠️ Tools & Technologies

- **SQL (BigQuery)** – for event cleaning and funnel data aggregation  
- **Google Sheets / Excel** – for organizing and visualizing funnel steps  
- **Funnel charts & Tables** – for retention/drop-off analysis

## 🧪 Methodology

### 1. Data Exploration & Cleaning  
- Explored `raw_events` to understand the structure and available event types  
- Removed duplicate user events by selecting only the **first occurrence** per `user_pseudo_id` and event type, based on `event_timestamp`

### 2. Event Selection  
- Selected 4–6 meaningful events to represent key steps in the sales funnel  
- Ensured only **unique event progressions** were counted to avoid inflating results due to repeated behavior

### 3. Funnel Construction  
- Identified the **top 3 countries** by overall event volume  
- Aggregated user progression through the funnel stages for each top country  
- Calculated event order and **percentage drop-off** between funnel steps

### 4. Visualization  
- Created **funnel charts** split by country to compare user journeys  
- Applied formatting and conditional styling to highlight insights  
- Explored alternative views and segments for deeper analysis

## 📊 Output Example

- Funnel table with event names, counts, and drop-off %
- Funnel chart for each of the top 3 countries
- Optional split by additional dimensions (e.g., device type)

## 💡 Key Insights

- Highlighted significant drop-off stages across countries  
- Noted differences in conversion behaviors across regions  
- Proposed further segmentation ideas to refine user journey understanding

## ✅ Evaluation Criteria Met

- Cleaned and structured event data with proper deduplication  
- Funnel chart with country-level split and clear visual storytelling  
- Analytical explanation of results and drop-off rates  
- Well-formatted output for easy review and stakeholder sharing

## ❓ Sample Review Questions

- How did you define and validate funnel events?
- How did you eliminate duplicated events?
- What trends stood out across countries?
- What business improvements could this data inform?
