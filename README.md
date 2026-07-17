# Laundryheap Data Analysis

An end-to-end data analysis project modelled after **Laundryheap** — an on-demand laundry and dry cleaning startup operating in Bangalore, India.

This project simulates a real-world business analytics workflow across **Excel, SQL and Power BI** — from raw data generation to actionable business insights.

---

## 📁 Project Structure

```
Laundryheap-Data-Analysis/
│
├── customers.csv              # 500 customer records across 12 Bangalore areas
├── riders.csv                 # 60 delivery riders with performance data
├── facilities.csv             # 8 laundry processing centers
├── orders.csv                 # 3000 orders connecting all tables
│
├── Laundryheap_Analysis_Cleaned.xlsx   # Excel workbook — cleaning + EDA
├── LH_Analysis_Queries.sql             # 25 SQL business problem statements
└── README.md
```

---

## 🗄️ Dataset Overview

A synthetic relational dataset generated using Python (Faker + Pandas) with realistic business data.

| Table | Rows | Description |
|---|---|---|
| customers | 500 | Customer profiles across 12 Bangalore areas |
| riders | 60 | Delivery agents with vehicle and rating data |
| facilities | 8 | Laundry centers with capacity information |
| orders | 3000 | Core fact table with FK references to all 3 tables |

### Schema

```
customers (customer_id PK) ──< orders (customer_id FK)
riders    (rider_id PK)    ──< orders (rider_id FK)
facilities (facility_id PK)──< orders (facility_id FK)
```

---

## 🛠️ Tools Used

| Tool | Purpose |
|---|---|
| Python (Faker, Pandas) | Synthetic dataset generation |
| Microsoft Excel | Data cleaning, null audit, EDA |
| SQL Server (SSMS) | Business analysis — 25 queries |
| Power BI | Interactive dashboard |
| GitHub | Version control |

---

## 📊 Excel — Data Cleaning

- Imported all 4 CSVs into a structured multi-sheet workbook
- Performed null audit across all tables
- Validated foreign key integrity using COUNTIF
- Highlighted valid nulls (cancelled orders) vs data quality issues
- Added `delivery_duration_hrs` helper column using Excel formula
- Applied conditional formatting for visual data quality review

---

## 🗄️ SQL — 25 Business Problem Statements

Queries written in **T-SQL (SSMS)** covering:

| Level | Concepts |
|---|---|
| 🟢 Easy (Q1–Q5) | COUNT, SUM, WHERE, ORDER BY |
| 🟡 Medium (Q6–Q13) | JOINs, GROUP BY, HAVING, AVG |
| 🔴 Hard (Q14–Q20) | CTEs, Window Functions, DATE functions |
| 🔴🔴 Advanced (Q21–Q25) | RFM Analysis, Multi-step CTEs, Capacity Analysis |

### Key queries include:
- Month-over-month revenue trend for 2024
- Customer churn identification (last order > 6 months ago)
- Rider ranking by service type using DENSE_RANK
- RFM customer segmentation (Recency, Frequency, Monetary)
- Facility capacity utilization analysis

---

## 💡 Key Business Insights

| Insight | Finding |
|---|---|
| Total Revenue | ₹40.6 lakhs across 3000 orders |
| Order Completion Rate | Only 66.7% — 33.3% delayed or cancelled 🚨 |
| Top Revenue Area | Malleshwaram — ₹4.4 lakhs |
| Best Service by Revenue | Premium Care — wins 9 out of 12 months |
| Customer Churn Rate | 21.2% — 106 customers lost 🚨 |
| Repeat Order Rate | 98.6% — strong customer loyalty ✅ |
| High Risk Customers | 123 used promo but rated below 3.5 |
| Top Customer | Bhavini Pillai — 15 orders, ₹23,788 spent |
| Best Rated Rider | Priya Shan — 4.2 avg rating |
| Fastest Facility | Whitefield — 16.7 hrs avg delivery |

---

## 📈 Power BI Dashboard

Interactive dashboard with 4 pages:
- **Overview** — KPI cards, total revenue, order completion rate
- **Customer** — Top spenders, area-wise revenue, churn analysis
- **Operations** — Rider performance, facility utilization
- **Trends** — Monthly revenue, service type breakdown

---

## 🚀 How to Run

1. Clone this repo
2. Import CSVs into SQL Server as `LaundryheapDB`
3. Run `LH_Analysis_Queries.sql` in SSMS
4. Open `Laundryheap_Analysis_Cleaned.xlsx` in Excel
5. Connect Power BI to `LaundryheapDB` for dashboard

---

## 👤 Author

**Manasa**
Data Analyst | SQL · Excel · Power BI · Python

🔗 [GitHub](https://github.com/manasa-data) | 📸 [Instagram @just.sql.things](https://instagram.com/just.sql.things)
