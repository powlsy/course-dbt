{{
    config(
        materialized = 'view'
    )
}}

select 
    user_id
    , {{ dbt_privacy.mask_email("email", n=4, domain_n=0,) }} as masked_email
 from {{ ref('stg_users') }}