{{ config(
    materialized='table',
    unique_key=['complaint_key']
) }}

WITH source_complaints AS (

    -- Select the distinct columns that defiene a unique complaint type
    SELECT DISTINCT
        complaint_type,
        -- The descriptor column will serve as the most detailed attribute
        descriptor,
    FROM {{ ref('stg_nyc_311_dot') }}
    WHERE complaint_type IS NOT NULL

),

final AS (

    SELECT
        -- Generate a stable surrogate key based on the unique complaint attributes
        {{ dbt_utils.generate_surrogate_key([
            'complaint_type',
            'descriptor'
        ]) }} AS complaint_key,

        complaint_type,
        descriptor

    FROM source_complaints
)

SELECT * FROM final
