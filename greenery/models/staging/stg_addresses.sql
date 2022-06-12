{{
  config(
    materialized='table'
  )
}}

SELECT 
    address_id,
    address as street_address,
    zipcode as zip,
    state,
    country
FROM {{ source('staging', 'addresses') }}