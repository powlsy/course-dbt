{{
    config(
        materialized = 'table' 
    )
}}

with users as (
    select 
      user_id
    , first_name
    , last_name
    , email
    , phone_number
    , created_at_utc
    , updated_at_utc
    , street_address
    , zip
    , state
    , country
    from {{ ref('stg_users')}}
    join {{ ref('stg_addresses')}}
    using (address_id)
)

select * from users

