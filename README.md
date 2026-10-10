# Kevin Marcelin — Data Analytics Portfolio

Data & Business Analyst (M.S. Business Analytics, Baruch Zicklin). I build
end-to-end analytics: modeling messy real-world data, writing tested SQL/dbt
pipelines, and turning the results into clear business decisions.

**Toolbox:** SQL · Python (pandas, statsmodels) · dbt · BigQuery · Excel (XLOOKUP, pivot tables) · Tableau

📍 New York, NY · [LinkedIn](https://www.linkedin.com/in/Kevin-marcelin-data-analyst/) · kevinmarcelin7@gmail.com

---

## Projects

### 1. 📦 [Delivery Performance Analysis](https://github.com/KevMarcel0/delivery-performance-analysis)
What drives late deliveries, and what do they cost? Analysis of 96,470 real delivered
orders from the Olist Brazilian e-commerce dataset: cleaning and joining six tables in
Python, SQL analysis in BigQuery, Excel pivots, and a Tableau dashboard.

- **Found:** 93.2% of orders arrived on time, but late deliveries cluster in the north
  and northeast, and light, low-value items like electronics pay up to 68.7% of their
  order value in freight.
- **Stack:** Python (pandas), SQL (BigQuery), Excel, Tableau.
- → [`delivery-performance-analysis`](https://github.com/KevMarcel0/delivery-performance-analysis)

### 2. 🚗 [Crash Fatality Risk — Logistic Regression](crash-fatality-regression/)
Statistical modeling on **89,000+ real motor-vehicle crash records**: do certain
vehicles carry higher fatal-crash risk once driver, vehicle, and environmental
factors are controlled for? Simple and multiple logistic regression.

- **Stack:** Python — statsmodels, pandas, numpy, scipy, matplotlib/seaborn.
- → [`crash-fatality-regression/`](crash-fatality-regression/)

### 3. 🏙️ [NYC Real Estate Investment Analytics (dbt + BigQuery)](nyc-real-estate-dbt/)
Team project (CIS 9440, Baruch). A tested **dbt + BigQuery** warehouse joining NYC
Dept. of Finance neighborhood sales with 4.3 million 311 DOT complaints, loaded with a
Google Cloud Function, to find where people buy 1-3 family homes with fewer
infrastructure complaints.

- **Found:** Staten Island had the fewest DOT complaints per home sale (4.0) and the
  lowest prices, Queens had the most sales (7.7 complaints per sale), and the Bronx
  costs about the same as Staten Island with over 3 times the complaints.
- **My role:** team coordinator for a group of four. Built the staging models, `dim_neighborhood`, `dim_home_type`, `dim_complaint`, and the `home_type_sold_by_year` analytics table.
- **Stack:** Cloud Functions, BigQuery, dbt, SQL, Looker Studio.
- → [`nyc-real-estate-dbt/`](nyc-real-estate-dbt/)

---

Each project has its own README with the full write-up and run instructions.
