{{
  config(
    materialized='table'
  )
}}

SELECT 
    event_id,
    session_id,
    user_id,
    page_url,
    created_at AS created_at_utc,
    event_type,
    order_id,
    product_id
FROM {{ source('staging', 'events') }}