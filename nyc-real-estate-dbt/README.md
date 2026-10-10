# NYC Real Estate Investment Analytics (dbt + BigQuery)

**Question:** Where in NYC are people buying 1-3 family homes, but with fewer street and infrastructure complaints for the amount of activity?

Team project for CIS 9440 (Data Warehousing & Analytics) at Baruch, built with three classmates. We modeled NYC Department of Finance neighborhood sales against 311 Department of Transportation complaints for a real estate investor looking for long-term rental properties.

**My role:** team coordinator. In dbt I built the staging models, three dimension tables (`dim_neighborhood`, `dim_home_type`, `dim_complaint`), and the `home_type_sold_by_year` analytics table behind the housing type chart. I also kept the four of us on track with deadlines and tasks across 11 meetings.

**Tools:** Google Cloud Functions, BigQuery, dbt, SQL, Looker Studio

## The Data

- **DOF Neighborhood Sales:** 8,987 rows of sales counts and prices by borough, neighborhood, home type, and year (2010-2024)
- **311 Service Requests:** 4.3 million complaints, filtered to the Department of Transportation (potholes, street lights, signals, signs, street conditions)

## Pipeline

1. A Python Cloud Function pulls the data from NYC Open Data (Socrata API), cleans the column names, and loads it into BigQuery.
2. dbt builds staging models, two star schemas, and analytics tables on top.
3. Looker Studio for the final visuals.

Full write-up: [`docs/final-report.md`](docs/final-report.md)

```
Raw (BigQuery: nyc_sales_raw_data)
  |
models/staging/      clean, standardize, dedup (views)
  stg_nyc_neighborhood_sales.sql
  stg_nyc_311_dot.sql
  |
models/marts/        star schemas (tables)
  neighborhood_sales/  dim_neighborhood, dim_home_type, dim_sales_year, fact_neighborhood
  dot_311/             dim_complaint, dim_location, dim_date, fact_311_requests
  |
models/analytics/    business-ready tables
  borough_year_311_sales.sql   (complaints per sale)
  neighborhood_sales_combined_summary.sql
  complaints_by_year_borough_type.sql
  home_type_sold_by_year.sql
```

- Lineage graph: [`docs/lineage-graph.png`](docs/lineage-graph.png)
- Data model (dbdiagram.io): [`docs/data-model.dbml`](docs/data-model.dbml)

## How It Was Cleaned

- Standardized borough names across both datasets.
- Validated NYC zip codes (5 digit, 9 digit, and ZIP+4) and parsed timestamps.
- Removed duplicates with `QUALIFY ROW_NUMBER()`.
- Kept only DOT complaints from the last 7 years.
- Added tests: `unique` and `not_null` on every key, `accepted_values` on borough, and `relationships` tests so every fact row matches a real dimension row.

**Data issue found later:** the sales data stores boroughs as names for 2010-2021 but as numeric codes (1-5) for 2022-2024. The original staging model only mapped names, so all 1,807 rows from 2022-2024 (60,419 sales) fell into "UNKNOWN" and dropped out of the borough results. The model now maps both.

## What We Found

1. **Street Condition is the biggest DOT complaint**, followed by Traffic Signal and Street Light. Roadway and traffic problems drive most complaints.
2. **Complaints don't follow a steady trend.** They jumped from 2018 to 2019, dipped in 2020, peaked around 2022, and leveled off through 2025.
3. **Higher prices don't mean fewer complaints.** At the neighborhood level there was no clear link between median sale price and complaint volume. Complaints seem to follow how busy and dense an area is, not how wealthy it is.
4. **One-family homes are about half of all sales every year**, then two-family, then three-family, and that mix barely changes.
5. **At the borough level, Queens and Staten Island have fewer complaints at moderate prices**, while Manhattan and Brooklyn combine higher prices with more complaints.

DOT complaints per home sale by borough, 2019-2024 (calculated after the borough fix above):

| Borough | Home sales | DOT complaints | Complaints per sale | Avg median price |
|---|---|---|---|---|
| Staten Island | 26,314 | 104,923 | 4.0 | $737K |
| Queens | 51,193 | 394,321 | 7.7 | $940K |
| Brooklyn | 34,921 | 381,318 | 10.9 | $1.69M |
| Bronx | 14,352 | 189,023 | 13.2 | $743K |
| Manhattan | 1,284 | 229,521 | 178.8 | $5.65M |

- Staten Island had the fewest complaints per sale (4.0) and the lowest median prices.
- Queens had the most sales by far (51,193) with the second lowest complaint rate.
- The Bronx is priced about the same as Staten Island but has more than 3 times the complaints per sale.
- Manhattan barely sells 1-3 family homes, so its number is high mostly because there are so few sales.

## Recommendation

For an investor looking at 1-3 family homes, Staten Island and Queens have the best mix of lower prices, steady sales, and fewer infrastructure complaints. The Bronx looks cheap, but it comes with a lot more complaints for the same price.

## What It Doesn't Answer

- DOT complaints are about streets and infrastructure, not housing conditions inside buildings.
- Complaints are compared at the borough level, so this doesn't rank individual neighborhoods.
- Crime, schools, and rents weren't included.

## Running It

```bash
pip install dbt-bigquery
dbt deps
cp profiles.example.yml ~/.dbt/profiles.yml   # then add your project and dataset
dbt build
```

Source definitions are in [`models/staging/sources.yml`](models/staging/sources.yml).
