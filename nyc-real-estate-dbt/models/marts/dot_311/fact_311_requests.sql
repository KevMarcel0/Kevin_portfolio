{{ config(
    materialized='table',
    unique_key=['service_request_id']
) }}

WITH raw_requests AS (
    SELECT
        -- Pull the business key and natural keys from the staging model
        request_id AS service_request_id,
        status,
        -- Natural keys for joining to dimensions:
        complaint_type,
        descriptor,
        borough,
        incident_zip AS zip_code,
        latitude,
        longitude,
        created_date
        
    FROM {{ ref('stg_nyc_311_dot') }}
    WHERE created_date IS NOT NULL
),

final_fact AS (
    SELECT
        -- Generate the surrogate fact key (optional, as raw ID can serve as PK)
        {{ dbt_utils.generate_surrogate_key(['r.service_request_id']) }} AS request_key,
        r.service_request_id,
        r.status,
        
        -- Look up Foreign Keys from Dimensions
        c.complaint_key,
        l.location_key,
        d.date_key
        
    FROM raw_requests r
    
    -- 1. Join to Complaint Dimension
    INNER JOIN {{ ref('dim_complaint') }} c
      ON r.complaint_type = c.complaint_type
      AND r.descriptor = c.descriptor 
      
    -- 2. Join to Location Dimension
    INNER JOIN {{ ref('dim_location') }} l
      ON r.borough = l.borough
      AND r.zip_code = l.zip_code
      AND r.latitude = l.latitude
      AND r.longitude = l.longitude
      -- Note: Ensure dim_location uses these four fields to generate its key
      
    -- 3. Join to Date Dimension (using the full timestamp)
    INNER JOIN {{ ref('dim_date') }} d
      -- Assumes dim_date has a column named full_date corresponding to the created_date timestamp
      ON r.created_date = d.full_date 
)

SELECT * FROM final_fact
