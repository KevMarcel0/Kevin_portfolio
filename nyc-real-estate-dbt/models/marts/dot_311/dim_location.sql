{{ config(
    materialized='table',
    unique_key=['location_key']
) }}

WITH source_locations AS (

    -- Select the distinct columns that define a unique location
    SELECT DISTINCT
        borough,
        incident_address AS street_name, -- Renaming raw column to fit the model blueprint
        -- Note: The raw column is 'incident_address' in sources.yml, not 'house_number'
        incident_zip AS zip_code,
        latitude,
        longitude
        -- neighborhood is not explicitly listed in sources.yml for this table, 
        -- so we rely on the available columns for location uniqueness.
        
    FROM {{ ref('stg_nyc_311_dot') }}
    -- Filter out rows with no useful coordinates
    WHERE latitude IS NOT NULL AND longitude IS NOT NULL
),

final AS (

    SELECT
        -- Generate a stable surrogate key by hashing the defining location attributes
        {{ dbt_utils.generate_surrogate_key([
            'borough',
            'zip_code',
            'latitude',
            'longitude',
            'street_name'
        ]) }} AS location_key,

        borough,
        zip_code,
        latitude,
        longitude,
        street_name
        -- If a neighborhood column is available in stg_nyc_311_dot, add it here

    FROM source_locations
)

SELECT * FROM final
