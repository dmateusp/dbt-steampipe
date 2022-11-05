{{ config(materialized='table') }}

with

job_bytes as (
    select
        job_id,
        (labels #>> '{dataflow_job_name}') as job_name,
        user_email,
        creation_time,
        total_bytes_processed
    from {{ ref("bq_billable_bytes") }}
),

pricing as (
    select "type", price_per_tb_dollar
    from {{ ref("bq_pricing") }}
)

select
    job_bytes.job_id,
    job_bytes.job_name,
    job_bytes.user_email,
    job_bytes.creation_time,
    pricing."type",
    pg_size_pretty(job_bytes.total_bytes_processed) as size_processed,
    (job_bytes.total_bytes_processed * pow(10, -12)) * pricing.price_per_tb_dollar as total_cost
from job_bytes
cross join pricing
order by total_cost desc

