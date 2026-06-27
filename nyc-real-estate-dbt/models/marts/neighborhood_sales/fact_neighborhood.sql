{{ config(
    materialized='table',
    unique_key='fact_key'
) }}

WITH sales_data AS (
    SELECT
        -- IDs and Join Keys (Must match what is in the Dimensions!)
        borough,          -- Raw column (matches dim_neighborhood)
        neighborhood,     -- Raw column (matches dim_neighborhood)
        type_of_home,     -- Raw column (matches dim_home_type)
        year,             -- Raw column (matches dim_sales_year)
        
        -- Metrics (Use the cleaned numeric columns from staging)
        total_number_of_sales,
        lowest_sale_price_usd,
        average_sale_price_usd,
        median_sale_price_usd,
        highest_sale_price_usd
        
    FROM {{ ref('stg_nyc_neighborhood_sales') }}
    WHERE year IS NOT NULL
),

final_fact AS (
    SELECT
        -- Generate a unique key for the fact table
        {{ dbt_utils.generate_surrogate_key(['s.borough', 's.neighborhood', 's.type_of_home', 's.year']) }} AS fact_key,
        
        -- Foreign keys from dimensions
        y.year_key,
        n.neighborhood_key,
        h.home_type_key,
        
        -- Metrics
        s.total_number_of_sales AS number_of_sales,
        s.lowest_sale_price_usd AS lowest_sale_price,
        s.average_sale_price_usd AS average_sale_price,
        s.median_sale_price_usd AS median_sale_price,
        s.highest_sale_price_usd AS highest_sale_price
        
    FROM sales_data s

    -- Join to Year Dimension
    INNER JOIN {{ ref('dim_sales_year') }} y
      ON s.year = y.year

    -- Join to Neighborhood Dimension
    -- CRITICAL FIX: Joining on the raw columns because that is what the Dimension uses
    INNER JOIN {{ ref('dim_neighborhood') }} n
      ON s.borough = n.borough
     AND s.neighborhood = n.neighborhood

    -- Join to Home Type Dimension
    INNER JOIN {{ ref('dim_home_type') }} h
      ON s.type_of_home = h.type_of_home
)

SELECT * FROM final_fact
