{{ config(
    materialized='table',
    unique_key='home_type_key'
) }}

WITH home_types AS (
    SELECT DISTINCT
        type_of_home
    FROM {{ ref('stg_nyc_neighborhood_sales') }}
    WHERE type_of_home IS NOT NULL
),

dimension AS (
    SELECT
        -- Surrogate key using the home type
        {{ dbt_utils.generate_surrogate_key(['type_of_home']) }} AS home_type_key,
        type_of_home
    FROM home_types
)

SELECT *
FROM dimension
