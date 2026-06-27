WITH final_agg_fact AS (

    SELECT 
    year_value AS year_of_complaints,
    complaint_type,
    borough,
    COUNT(*) AS total_complaints 
    
       
        
    FROM {{ ref('fact_311_requests')}} f
       LEFT JOIN {{ ref ('dim_complaint')}} dc
          ON f.complaint_key = dc.complaint_key
        LEFT JOIN {{ ref ('dim_date')}} dy
          ON f.date_key = dy.date_key
        LEFT JOIN {{ ref ('dim_location')}} dl
          ON f.location_key = dl.location_key



        Group BY year_value,complaint_type,borough
)
SELECT * FROM final_agg_fact
