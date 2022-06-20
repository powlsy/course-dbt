{{
    config(
        materialized = 'table' 
    )
}}

with fact_pg_views as (
    SELECT
    page_url
    ,COUNT( distinct session_id) as page_views
    ,MIN(created_at_utc) as last_opened_utc
    FROM {{ref('stg_events')}}
    WHERE event_type = 'page_view'
    GROUP BY page_url
)

SELECT * from fact_pg_views