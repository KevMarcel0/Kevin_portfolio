# Kevin Marcelin: Data Analytics Portfolio

Data analyst focused on logistics and operations. M.S. Business Analytics candidate at Baruch (June 2027). I clean messy data, analyze it in SQL, Python, and Excel, and turn it into dashboards and recommendations.

**Tools:** SQL, Python (pandas, statsmodels), Excel (XLOOKUP, pivot tables), Tableau, BigQuery, dbt

New York, NY · [Website](https://kevmarcel0.github.io/Kevin_portfolio/) · [LinkedIn](https://www.linkedin.com/in/Kevin-marcelin-data-analyst/) · kevinmarcelin7@gmail.com

## Projects

### 1. [Delivery Performance Analysis](https://github.com/KevMarcel0/delivery-performance-analysis)

What drives late deliveries, and what do they cost? 96,470 real delivered orders from the Olist Brazilian e-commerce dataset: cleaned and joined six tables in Python, analyzed in BigQuery SQL, built Excel pivots and a Tableau dashboard.

- **Found:** 93.2% of orders arrived on time, but late deliveries cluster in the north and northeast, and light, low-value items like electronics pay up to 68.7% of their order value in freight.
- **Tools:** Python (pandas), SQL (BigQuery), Excel, Tableau
- **Repo:** [delivery-performance-analysis](https://github.com/KevMarcel0/delivery-performance-analysis)

### 2. [Crash Fatality Risk: Logistic Regression](crash-fatality-regression/)

Team project (CIS 9660, group of three). Are Fords more likely to be in fatal crashes once driver, vehicle, and timing factors are controlled for? Simple and multiple logistic regression on 64,791 NYC crash records.

- **Found:** on their own, Fords had about 2.3 times the odds of a fatal crash, but the effect wasn't significant once other factors were added. Unlicensed drivers had about 6 times the odds.
- **Tools:** Python (statsmodels, pandas, numpy, scipy), Excel
- **Folder:** [crash-fatality-regression](crash-fatality-regression/)

### 3. [NYC Real Estate Investment Analytics](nyc-real-estate-dbt/)

Team project (CIS 9440, group of four). A tested dbt and BigQuery warehouse joining NYC Department of Finance home sales with 4.3 million 311 DOT complaints, loaded with a Google Cloud Function, to find where people buy 1-3 family homes with fewer infrastructure complaints.

- **Found:** Staten Island had the fewest DOT complaints per home sale (4.0) and the lowest prices, Queens had the most sales (7.7 complaints per sale), and the Bronx costs about the same as Staten Island with over 3 times the complaints.
- **My role:** team coordinator. Built the staging models, `dim_neighborhood`, `dim_home_type`, `dim_complaint`, and the `home_type_sold_by_year` analytics table.
- **Tools:** Cloud Functions, BigQuery, dbt, SQL, Looker Studio
- **Folder:** [nyc-real-estate-dbt](nyc-real-estate-dbt/)

Each project has its own README with the full write-up and how to run it.
