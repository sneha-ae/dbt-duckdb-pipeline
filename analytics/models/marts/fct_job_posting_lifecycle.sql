with scrapes as (
    select
        job_id,
        min(search_date) as first_seen,
        max(search_date) as last_seen,
        count(*) as times_scraped,
        count(distinct search_date) as days_seen
    from {{ ref('stg_raw__job_postings') }}
    where job_id is not null
    group by job_id
),

latest as (
    select
        job_id,
        job_title,
        company_name,
        job_location,
        job_via,
        search_term
    from {{ ref('stg_raw__job_postings') }}
    where job_id is not null
    qualify row_number() over (partition by job_id order by search_date desc) = 1
)

select
    latest.job_id,
    latest.job_title,
    latest.company_name,
    latest.job_location,
    latest.job_via,
    latest.search_term,
    scrapes.first_seen,
    scrapes.last_seen,
    scrapes.times_scraped,
    scrapes.days_seen,
    cast(date_diff('day', scrapes.first_seen, scrapes.last_seen) + 1 as bigint) as days_live
from scrapes
inner join latest using (job_id)