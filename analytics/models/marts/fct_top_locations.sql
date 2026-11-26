SELECT 
    job_location,
    COUNT(*) AS postings
FROM {{ ref('stg_raw__job_postings') }}
GROUP BY job_location
ORDER BY postings DESC
LIMIT 10