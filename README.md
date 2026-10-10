# Kevin Marcelin — Data Analytics Portfolio

Data & Business Analyst (M.S. Business Analytics, Baruch Zicklin). I build
end-to-end analytics: modeling messy real-world data, writing tested SQL/dbt
pipelines, and turning the results into clear business decisions.

**Toolbox:** SQL · Python (pandas, statsmodels) · dbt · BigQuery · SQLite · Power BI · data visualization

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
A tested **dbt + BigQuery** warehouse joining NYC Dept. of Finance neighborhood
sales with 311 DOT complaints to find neighborhoods with strong demand and low
infrastructure friction. Standard **staging → marts (star schema) → analytics**
layering with source, uniqueness, and fact-to-dimension `relationships` tests.

- **Stack:** dbt, SQL, Google BigQuery, dbt_utils, NYC Open Data.
- → [`nyc-real-estate-dbt/`](nyc-real-estate-dbt/)

---

Each project has its own README with the full write-up and run instructions.
