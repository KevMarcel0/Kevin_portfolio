{{ config(
    materialized='table',
    unique_key=['year_key']
) }}

WITH years AS (
    SELECT DISTINCT
        year
    FROM {{ ref('stg_nyc_neighborhood_sales') }}
    WHERE year IS NOT NULL
),

sales_year_dimension AS (
    SELECT
        -- surrogate key based on the year value
        {{ dbt_utils.generate_surrogate_key(['year']) }} AS year_key,
        year
    FROM years
)

SELECT *
FROM sales_year_dimension
