# 🏙️ NYC Real Estate Investment Analytics (dbt + BigQuery)

**Find the NYC neighborhoods with strong housing demand *and* low quality-of-life friction** — by modeling Department of Finance neighborhood sales against 311 Department of Transportation complaints in a clean, tested dbt warehouse.

> Built on **dbt + Google BigQuery** using NYC Open Data. The project follows a
> standard **staging → marts (star schema) → analytics** layering, with source
> freshness/uniqueness tests and fact-to-dimension `relationships` tests.

---

## 🎯 The question

Real estate investors want areas where people are **buying** (high, rising sales)
but where infrastructure complaints (potholes, signals, signs, street conditions —
all DOT 311 requests) are **low relative to activity**. This project joins two very
different NYC Open Data sources to surface exactly that signal:

- **DOF Neighborhood Sales** — sales counts and price stats by borough / neighborhood / home type / year
- **311 DOT Service Requests** — infrastructure complaints by location and date

The headline metric is **`complaints_per_sale`** at the borough × year grain, plus a
neighborhood-level `complaints_per_neighborhood_sale`.

---

## 🧱 Architecture

```
Raw (BigQuery: nyc_sales_raw_data)
        │
        ▼
models/staging/          ← clean, standardize, dedup (materialized: view)
  ├─ stg_nyc_neighborhood_sales.sql
  └─ stg_nyc_311_dot.sql
        │
        ▼
models/marts/            ← dimensional model (materialized: table)
  ├─ neighborhood_sales/  dim_neighborhood, dim_home_type, dim_sales_year, fact_neighborhood
  └─ dot_311/             dim_complaint, dim_location, dim_date, fact_311_requests
        │
        ▼
models/analytics/        ← business-ready aggregates (materialized: table)
  ├─ borough_year_311_sales.sql            (core complaints-per-sale signal)
  ├─ neighborhood_sales_combined_summary.sql
  ├─ complaints_by_year_borough_type.sql
  └─ home_type_sold_by_year.sql
```

A rendered lineage graph is in [`docs/lineage-graph.png`](docs/lineage-graph.png).

---

## ✨ Engineering highlights

- **Two star schemas** (sales + complaints) with surrogate keys via `dbt_utils.generate_surrogate_key`.
- **Real cleaning logic** in staging: borough standardization, NYC zip validation
  (5 / 9 / ZIP+4), timestamp parsing, and `QUALIFY ROW_NUMBER()` deduplication.
- **Tested data contracts**: `unique` / `not_null` on every key, `accepted_values`
  on borough, and `relationships` tests so every fact row resolves to a real dimension row.
- **Layered materializations** configured in `dbt_project.yml` (views for staging, tables downstream).

---

## ▶️ Running it

```bash
pip install dbt-bigquery
dbt deps                     # installs dbt_utils (see packages.yml)

# configure your warehouse — copy the template and edit:
cp profiles.example.yml ~/.dbt/profiles.yml

dbt build                    # runs all models + tests
# or step by step:
dbt run                      # build the models
dbt test                     # run the data tests
dbt docs generate && dbt docs serve   # browse the lineage graph + docs
```

Source data comes from NYC Open Data (DOF Annual Sales / Rolling Sales and the
311 Service Requests dataset) loaded into a BigQuery raw dataset — see
[`models/staging/sources.yml`](models/staging/sources.yml).

---

## 🛠️ Tech stack

**dbt** · **Google BigQuery** · **SQL** · dbt_utils · NYC Open Data · Git
