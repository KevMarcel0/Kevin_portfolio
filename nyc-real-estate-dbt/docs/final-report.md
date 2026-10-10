# Final Project Report

CIS 9440 Data Warehousing & Analytics, Baruch College, Fall 2025. Team project (4 members).

## 1. Introduction

### 1.1 Project Overview

This project analyzes New York City neighborhood sales and DOT-related 311 complaints to help identify profitable, low-complaint areas for long-term real estate investment. Our goal is to understand which boroughs and neighborhoods offer strong investment potential by balancing affordability, demand, and quality-of-life indicators. Specifically, we focus on how complaint volume, particularly DOT complaints related to streets, sidewalks, and traffic issues, interacts with home sales, median sale prices, and neighborhood characteristics.

The problem real estate investors face is simple: where should they invest to maximize long-term rental profitability while minimizing property-related issues? Our analysis supports this by comparing complaint trends with home sale trends and identifying neighborhoods with strong investment value.

### 1.2 Analytics Questions

1. Are lower-complaint boroughs associated with lower or higher home sale prices?
2. Which borough shows the worst combination of high complaints and high home prices?
3. How do DOT complaint trends compare to yearly home sale trends across boroughs?
4. Which neighborhoods have the highest and lowest total complaints?
5. What types of homes (1-, 2-, and 3-family) are being sold each year, and where?

### 1.3 Stakeholders

The primary stakeholders are real estate investors seeking long-term property value and minimal tenant-related issues. Property managers may also benefit, since understanding complaint patterns can support operational planning and tenant satisfaction. City planners and housing analysts can use the findings to identify neighborhood-level trends and inform decisions on urban development and housing policy.

### 1.4 Data Sources

All datasets came from NYC Open Data and were loaded into BigQuery using Cloud Functions and dbt models. The 311 Service Requests dataset contains citywide complaints from 2010 to the present. We filtered it to Department of Transportation (DOT) complaint types such as street, sidewalk, and traffic issues, and used them as indicators of quality-of-life and infrastructure risk at the borough and neighborhood level. The NYC Neighborhood Sales dataset provides summarized sales by neighborhood, including total sales, median sale prices, and housing class (1-, 2-, and 3-family homes), and was used to evaluate affordability and long-term demand.

## 2. Dimensional Model

We kept each fact table's grain aligned with how its dataset naturally works. In `fact_311_service_request`, one row is one 311 complaint, tied to a complaint type, location, and date. In `fact_sales`, one row is one neighborhood's sales summary for a given year and home type, since the dataset already comes aggregated that way. Defining the grain clearly helped us avoid confusion when building dimensions and joining tables.

The 311 mart uses `dim_complaint`, `dim_location`, and `dim_date`, so complaints can be broken down by what happened, where, and when. The sales mart connects to `dim_neighborhood`, `dim_home_type`, and `dim_sales_year`, so we can compare neighborhoods, home types, and trends across years. The two datasets don't share the same time detail (311 data is daily, sales data is yearly), so forcing one shared date dimension wouldn't work. Keeping them separate with surrogate keys gave us a cleaner, more reliable model.

### 2.1 Challenges

- **Inconsistent borough naming across datasets.** The 311 data uses values like MANHATTAN and STATEN ISLAND, while the sales data has its own borough field. We normalized borough names in both sources so joins produced correct totals.
- **Missing or partial dates.** Some complaint records were missing a valid `created_date` and had to be filtered out to keep the year-level aggregates aligned.
- **Uneven coverage by neighborhood.** The sales data only includes neighborhoods with activity in a given year, so we built year-level and borough-level aggregates instead of forcing neighborhood-level joins that would be mostly nulls.
- **Complaint types not classified consistently.** DOT complaints appear under several categories (Street Condition, Sidewalk Condition, Traffic Signal, Street Light Condition), so we filtered complaint types carefully to keep "DOT complaints" consistent across years.
- **Large 311 volume.** We filtered to DOT complaints early, in the staging model, before aggregating.

### 2.2 Changes from Earlier Milestones

- **Switched from an incremental mart to a full refresh** after instructor feedback, since the goal was year-level totals, not tracking row-by-row changes.
- **Refined the grain** of the main fact table to Year × Complaint Type × Borough, so yearly summaries could join with yearly sales data.
- **Separated the models** into `stg_311_dot` (filtered DOT complaints), `stg_neighborhood_sales` (cleaned sales), and `borough_year_311_sales` (the combined mart), which reduced nulls and made the logic easier to follow.
- **Added year extraction** from 311 timestamps to match the sales data's yearly structure.

## 3. Data Processing & Technical Architecture

We built an end-to-end ELT pipeline for two NYC datasets. Raw data was loaded into BigQuery through a Google Cloud Function connected to the Socrata API (NYC Open Data). Along the way we fixed issues like project ID typos and adjusted settings so the large datasets wouldn't overload the function. Once the raw tables existed, we set up the dbt project and mapped the sources.

Staging models cleaned and standardized the data: standardizing borough names, casting numeric fields, creating composite identifiers, and removing duplicates. We generated surrogate keys with `dbt_utils.generate_surrogate_key`, and fixed models that didn't join correctly by rewriting fact tables to use the cleaned staging fields instead of raw ones.

After the marts were complete, we built an analytics layer that aggregated and joined the data to answer the business questions: borough-level metrics, summarized neighborhood sales, and complaint trends across time and location.

### 3.1 Key Transformations

- Filtered 311 data to DOT complaints (street, sidewalk, traffic, lighting).
- Standardized borough fields so both sources use the same five borough values.
- Extracted the year from complaint dates to match the yearly sales data.
- Cleaned and aggregated sales by borough and year (total sales and median price).
- Aggregated DOT complaints by borough and year.
- Built the combined mart, `borough_year_311_sales`, joining yearly complaint totals with yearly home sales.
- Set the final grain to Year × Borough.

## 4. Analysis & Visualizations (Looker)

**Highest complaint types.** Complaints are concentrated in a few categories: Street Condition is the largest, followed by Traffic Signal and Street Light complaints. Roadway and traffic infrastructure drive most reported DOT problems.

**Complaint trend by year.** Complaints rose sharply from 2018 to 2019, dipped in 2020, peaked around 2022, then declined and stabilized through 2025. Complaint activity moves with broader conditions rather than following a steady trend.

**Sale price vs. complaint volume.** Comparing median neighborhood sale price against total DOT complaints showed no clear correlation. Neighborhoods at every price level had both high and low complaint counts, which suggests complaints track population density and resident engagement more than neighborhood wealth.

**Housing type mix by year.** One-family homes make up about half of sales every year, followed by two-family homes, with three-family homes a smaller and steady share. The housing market's structure stays stable across years.

## 5. Conclusion

DOT complaints are concentrated in a few issue categories and vary over time, but they don't line up with neighborhood wealth. Higher prices don't mean fewer complaints. At the borough level, high-demand areas like Manhattan and Brooklyn combine higher prices with more complaints, while Queens and Staten Island more often show fewer complaints with moderate pricing.

Because the housing mix stays stable, shifts in complaints and prices aren't driven by changes in housing stock, which supports using complaint data as a quality-of-life signal. The borough-year mart allows consistent year-level comparisons for finding areas that balance affordability, demand, and lower operational risk, with limits from the different time detail of the two datasets and uneven neighborhood coverage.
