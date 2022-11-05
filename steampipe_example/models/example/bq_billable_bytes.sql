{{ config(materialized='table') }}

select
  job_id,
  user_email,
  total_bytes_processed,
  tags,
  labels,
  kind,
  creation_time,
  end_time
from {{ source("gcp", "gcp_bigquery_job") }}
where total_bytes_processed > 0
