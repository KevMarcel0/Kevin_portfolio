# Kevin Marcelin — Data Analytics Portfolio

Data & Business Analyst (M.S. Business Analytics, Baruch Zicklin). I build
end-to-end analytics: modeling messy real-world data, writing tested SQL/dbt
pipelines, and turning the results into clear business decisions.

**Toolbox:** SQL · Python (pandas, statsmodels) · dbt · BigQuery · SQLite · Power BI · data visualization

📍 New York, NY · [LinkedIn](https://www.linkedin.com/in/Kevin-marcelin-data-analyst/) · kevinmarcelin7@gmail.com

---

## Projects

### 1. 📦 [Supply Chain Analytics](supply-chain-analytics/)
End-to-end analytics on a logistics domain — **modeling → SQL → Python → visualization**.
Includes a self-built star schema on synthetic data *and* analysis of a **real
180,519-order public dataset** (DataCo Global).

- **Found:** a systemic 54.8% late-delivery rate, with the *premium* "First Class"
  tier late **95.3%** of the time — a broken delivery promise, not a regional problem.
- **Stack:** Python (pandas), SQL, SQLite, Power BI, matplotlib.
- → [`supply-chain-analytics/`](supply-chain-analytics/)

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

Each project folder has its own README with the full write-up and run instructions.
