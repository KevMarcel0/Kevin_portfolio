{{ config(
    materialized='table'
) }}

-- 1. Aggregate DOT complaints (from stg_nyc_311_dot)
WITH complaints AS (
    SELECT
        EXTRACT(YEAR FROM created_date) AS year,
        borough,
        COUNT(*) AS total_dot_complaints
    FROM {{ ref('stg_nyc_311_dot') }}
    GROUP BY year, borough
),

-- 2. Aggregate sales by borough + year (from stg_nyc_neighborhood_sales)
sales AS (
    SELECT
        CAST(year AS INT64) AS year,
        standardized_borough AS borough,
        SUM(total_number_of_sales) AS total_home_sales,
        AVG(median_sale_price_usd) AS avg_median_sale_price
    FROM {{ ref('stg_nyc_neighborhood_sales') }}
    GROUP BY year, standardized_borough
),

-- 3. Combine both datasets
combined AS (
    SELECT
        c.year,
        c.borough,
        c.total_dot_complaints,
        s.total_home_sales,
        s.avg_median_sale_price,
        SAFE_DIVIDE(c.total_dot_complaints, s.total_home_sales) AS complaints_per_sale
    FROM complaints c
    LEFT JOIN sales s
      ON c.year = s.year
     AND c.borough = s.borough
)

SELECT *
FROM combined
ORDER BY year, borough

