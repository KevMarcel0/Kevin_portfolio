{{ config(
    materialized='table'
) }}

WITH sales AS (
    SELECT
        CAST(year AS INT64) AS year,
        standardized_borough AS borough,
        cleaned_neighborhood AS neighborhood,
        total_number_of_sales,
        median_sale_price_usd,
        average_sale_price_usd,
        highest_sale_price_usd,
        lowest_sale_price_usd
    FROM {{ ref('stg_nyc_neighborhood_sales') }}
),

complaints AS (
    SELECT
        year,
        UPPER(TRIM(borough)) AS borough,
        total_dot_complaints,
        total_home_sales,
        avg_median_sale_price,
        complaints_per_sale
    FROM {{ ref('borough_year_311_sales') }}
)

SELECT
    s.year,
    s.borough,
    s.neighborhood,
    s.total_number_of_sales,
    s.median_sale_price_usd,
    s.average_sale_price_usd,
    s.highest_sale_price_usd,
    s.lowest_sale_price_usd,

    -- inherited borough-level complaints
    c.total_dot_complaints,
    c.complaints_per_sale,

    -- useful derived metric
    SAFE_DIVIDE(c.total_dot_complaints, s.total_number_of_sales) AS complaints_per_neighborhood_sale
FROM sales s
LEFT JOIN complaints c
  ON s.year = c.year
 AND UPPER(TRIM(s.borough)) = c.borough
ORDER BY s.borough, s.neighborhood, s.year

