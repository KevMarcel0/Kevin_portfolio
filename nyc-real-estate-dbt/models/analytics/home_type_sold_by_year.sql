{{ config (
    materialized = 'table'
) }}
 
WITH home_type_by_year AS (
    SELECT 
        y.year AS year_of_sales,                  -- Qualified with 'y.'
        h.type_of_home,                           -- Qualified with 'h.'
        SUM ( f.number_of_sales ) AS total_sales  -- Qualified with 'f.'
    FROM 
        {{ ref ( 'fact_neighborhood' ) }} f 
    JOIN 
        {{ ref ( 'dim_sales_year' ) }} y 
        ON f.year_key = y.year_key 
    JOIN 
        {{ ref ( 'dim_home_type' ) }} h 
        ON f.home_type_key = h.home_type_key 
    GROUP BY 
        y.year, h.type_of_home 
) 
 
SELECT 
    * FROM 
    home_type_by_year 
ORDER BY 
    year_of_sales DESC
