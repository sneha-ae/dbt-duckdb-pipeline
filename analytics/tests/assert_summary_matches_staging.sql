with stg as (
    select count(*) as n from {{ ref('stg_raw__job_postings') }}
),
mart as (
    select sum(total_postings) as n from {{ ref('fct_monthly_summary') }}
)
select
    stg.n as staging_rows,
    mart.n as summary_rows
from stg
cross join mart
where stg.n is distinct from mart.n