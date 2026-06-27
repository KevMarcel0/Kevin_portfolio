{{ config(
    materialized='table',
    unique_key='neighborhood_key'
) }}

WITH neighborhoods AS (
    SELECT DISTINCT
        borough,
        neighborhood
    FROM {{ ref('stg_nyc_neighborhood_sales') }}
    WHERE borough IS NOT NULL
      AND neighborhood IS NOT NULL
),

dimension AS (
    SELECT
        -- Surrogate key using borough + neighborhood
        {{ dbt_utils.generate_surrogate_key(['borough', 'neighborhood']) }} AS neighborhood_key,
        borough,
        neighborhood
    FROM neighborhoods
)

SELECT *
FROM dimension
