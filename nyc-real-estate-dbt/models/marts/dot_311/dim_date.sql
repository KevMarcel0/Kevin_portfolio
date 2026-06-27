{{ config(
    materialized='table',
    unique_key=['date_key']
) }}

WITH dates AS (
    SELECT DISTINCT
        -- Use the existing and correctly cast date column from the staging model
        created_date AS full_date,
        
        -- Extract date attributes
        EXTRACT(DAY FROM created_date) AS day,
        EXTRACT(MONTH FROM created_date) AS month,
        
        -- Use FORMAT_DATE for consistent Month Name extraction in BigQuery
        FORMAT_DATE('%B', DATE(created_date)) AS month_name,
        
        EXTRACT(QUARTER FROM created_date) AS quarter,
        EXTRACT(YEAR FROM created_date) AS year_value
        
    FROM {{ ref('stg_nyc_311_dot') }}
    -- Filter out rows where the base date is missing
    WHERE created_date IS NOT NULL
),

date_dimension AS (
    SELECT
        -- Generate the surrogate key based on the full date
        {{ dbt_utils.generate_surrogate_key(['full_date']) }} AS date_key,
        full_date,
        day,
        month,
        month_name,
        quarter,
        year_value
    FROM dates
)

SELECT *
FROM date_dimension
