{{
    config(
        materialized = 'table' 
    )
}}

with orders as (
    select 
    orders.order_id
    , orders.user_id
    , orders.promo_id
    , orders.address_id
    , case when orders.promo_id is not null then 1
        else 0
        end as has_promo
    , orders.created_at_utc as order_placed_utc
    , orders.order_cost_usd
    , orders.shipping_cost_usd
    , orders.order_total_usd
    , orders.tracking_id 
    , orders.shipping_service
    , orders.estimated_delivery_at_utc
    , orders.delivered_at_utc
    , orders.status
    , (promos.discount::float/100) as promo_discount_rate
    , order_products.num_products as num_products
    , order_products.num_items as num_items
    from {{ ref('stg_orders')}} as orders
    join {{ ref('int_order_products')}} as order_products
    using (order_id)
    left join {{ ref('stg_promos')}} as promos
    using (promo_id)
)

select * from orders