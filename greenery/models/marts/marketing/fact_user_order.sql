{{
    config(
        materialized = 'table' 
    )
}}

with fact as (
    select 
      users.user_id
    , users.zip
    , COUNT(orders.order_id) as num_orders
    , AVG(order_products.num_products::float) as avg_num_products
    , AVG(orders.order_total_usd) as avg_price_total_usd
    , SUM(order_products.num_items) as total_items_purchased
    , SUM(orders.order_total_usd) as total_spent_usd
    , MIN(orders.order_placed_utc) as first_order_placed_utc
    , MAX(orders.order_placed_utc) as last_order_placed_utc
    from {{ ref('fact_orders')}} as orders 
    left join {{ ref('dim_users')}} as users
    using (user_id)
    join {{ ref('int_order_products')}} as order_products
    using (order_id)
    group by users.user_id, users.zip
)

select * from fact