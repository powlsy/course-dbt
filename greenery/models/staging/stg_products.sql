{{
  config(
    materialized='table'
  )
}}

SELECT 
    product_id,
    name AS product_name,
    price AS price_usd,
    inventory
FROM {{ source('staging', 'products') }}