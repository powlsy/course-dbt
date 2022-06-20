{{
    config(
        materialized = 'table' 
    )
}}

with intermediate_op as (
    select 
    order_items.order_id
    , COUNT(products.product_id) as num_products
    , SUM(order_items.quantity) as num_items
    from {{ ref('stg_order_items')}} as order_items
    join {{ref('stg_products')}} as products
    using (product_id)
    group by 1
)

select * from intermediate_op