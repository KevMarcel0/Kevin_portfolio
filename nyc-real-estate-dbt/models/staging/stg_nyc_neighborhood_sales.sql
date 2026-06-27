WITH source AS (
    SELECT * FROM {{ source('raw', 'source_dof_neighborhood_sales') }}
),

cleaned AS (
    SELECT
        -- Retain all original columns for analysis
        *,

        -- Unique ID: We create a simple composite key by concatenating the identifying columns.
        CONCAT(
            CAST(borough AS STRING),
            '-',
            CAST(neighborhood AS STRING),
            '-',
            CAST(type_of_home AS STRING),
            '-',
            CAST(year AS STRING)
        ) AS sale_data_record_id,

        -- Standardize borough (using the standard NYC boroughs)
        CASE
            WHEN UPPER(TRIM(borough)) IN ('MANHATTAN', 'NEW YORK COUNTY') THEN 'Manhattan'
            WHEN UPPER(TRIM(borough)) IN ('BRONX', 'THE BRONX') THEN 'Bronx'
            WHEN UPPER(TRIM(borough)) IN ('BROOKLYN', 'KINGS COUNTY') THEN 'Brooklyn'
            WHEN UPPER(TRIM(borough)) IN ('QUEENS', 'QUEEN', 'QUEENS COUNTY') THEN 'Queens'
            WHEN UPPER(TRIM(borough)) IN ('STATEN ISLAND', 'RICHMOND COUNTY') THEN 'Staten Island'
            ELSE 'UNKNOWN'
        END AS standardized_borough,

        -- Standardize and clean core descriptive text fields
        TRIM(neighborhood) AS cleaned_neighborhood,
        TRIM(type_of_home) AS cleaned_type_of_home,

        -- Cast/Clean Numeric Metrics
        COALESCE(CAST(number_of_sales AS INTEGER), 0) AS total_number_of_sales,
        CAST(average_sale_price AS NUMERIC) AS average_sale_price_usd,
        CAST(median_sale_price AS NUMERIC) AS median_sale_price_usd,
        CAST(highest_sale_price AS NUMERIC) AS highest_sale_price_usd,
        CAST(lowest_sale_price AS NUMERIC) AS lowest_sale_price_usd,

        -- Metadata
        CURRENT_TIMESTAMP() AS _stg_loaded_at

    FROM source

    -- Basic filters: Ensure the core identifying columns are present
    WHERE borough IS NOT NULL
      AND neighborhood IS NOT NULL
      AND type_of_home IS NOT NULL
      AND year IS NOT NULL

    -- Deduplicate: Sales data is often unique per time/area/type combination.
    -- We partition by the unique combination and ensure one row per combination.
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY
            borough,
            neighborhood,
            type_of_home,
            year
        ORDER BY 1 -- Arbitrary ordering since no timestamp is available
    ) = 1
)

SELECT * FROM cleaned
