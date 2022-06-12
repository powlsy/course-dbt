{{
  config(
    materialized='table'
  )
}}

SELECT 
    order_id,
    user_id,
    promo_id,
    address_id,
    created_at AS created_at_utc,
    order_cost AS order_cost_usd,
    shipping_cost AS shipping_cost_usd,
    order_total AS order_total_usd,
    tracking_id,
    shipping_service,
    estimated_delivery_at AS estimated_delivery_at_utc,
    delivered_at AS delivered_at_utc,
    status
FROM {{ source('staging', 'orders') }}