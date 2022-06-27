How many users do we have?

>>>    SELECT COUNT(DISTINCT user_id)
>>>    FROM dbt_paul_g.stg_users;

130


On average, how many orders do we receive per hour?

>>>SELECT 
    SUM(orders_per_hour) / 24 as avg_orders_per_hour
FROM (
SELECT 
  count(order_id) AS orders_per_hour, 
  extract(hour from created_at_utc) as hour
FROM 
  dbt_paul_g.stg_orders
GROUP BY 
  hour
ORDER BY
  hour ASC) AS orders_per_hour;

15.04


On average, how long does an order take from being placed to being delivered?

>>>SELECT avg(hours) as avg_time_to_deliv_hrs 
FROM (
SELECT 
  order_id, 
  created_at_utc, 
  delivered_at_utc, 
  (delivered_at_utc - created_at_utc) as days_order_to_deliver,
  (EXTRACT (epoch FROM (delivered_at_utc - created_at_utc)))/3600 as hours
FROM dbt_paul_g.stg_orders
WHERE status='delivered') as time_in_hours

93.4 hours 

How many users have only made one purchase? Two purchases? Three+ purchases?

>>>SELECT
  CASE 
    WHEN order_count=1 THEN '1-One Purchase'
    WHEN order_count=2 THEN '2-Two Purchases'
    ELSE '3-Three+ Purchases' END AS purchase_segments, 
  count(user_id)
  FROM
    (
    SELECT 
      user_id, 
      count(order_id) as order_count
    FROM dbt_paul_g.stg_orders
    GROUP BY user_id) as _purchase_count
  GROUP BY purchase_segments

  1-One Purchase     25
  2-Two Purchases    28
  3-Three+ Purchases 71


Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase.

On average, how many unique sessions do we have per hour?

>>>with sess_per_hr(unq_sessions, day_hour) AS (
SELECT
  count(distinct session_id) as unq_sessions,
  day_hour
FROM
 (
SELECT 
  session_id,
  DATE_TRUNC('hour', created_at_utc) as day_hour
FROM 
  dbt_paul_g.stg_events
GROUP by
  day_hour, session_id) as day_hours
GROUP BY 
  day_hour
)

>>>SELECT avg(unq_sessions)
FROM sess_per_hr

16.33


=====
Week 2

Rate79,8%

```
WITH all_users AS 
(SELECT user_id, count(created_at_utc) as num_times_odered
FROM dbt_paul_g.stg_events
WHERE event_type='checkout'
GROUP BY user_id
),


totals as
(SELECT 
  (SELECT count(user_id)
FROM all_users
WHERE num_times_odered >1 
) as ordered_more_than_1_time,
 COUNT(user_id) as total
FROM 
all_users)

SELECT 
  CAST (ordered_more_than_1_time as decimal) / total as rate
FROM
  totals
```

=====
Week 3

What is our overall conversion rate?

```
select SUM(order_placed)::float/ COUNT(*)*100 as conversion_rate
from dbt_paul_g.fact_user_session
```

62.45


What is our conversion rate by product?

```
select 
dim_products.product_name
, ROUND(COUNT(stg_order_items.order_id)::float/COUNT(DISTINCT int_session_product.session_id)::float*100) as conv_rate
from dbt_paul_g.int_session_product
join dbt_paul_g.dim_products
using (product_id)
join dbt_paul_g.fact_user_session
using (session_id)
left join dbt_paul_g.stg_order_items
on int_session_product.product_id = stg_order_items.product_id
and fact_user_session.order_id = stg_order_items.order_id
group by 1
ORDER BY 2 DESC
```

product_name	conv_rate
String of pearls	61
Arrow Head	56
Cactus	55
Bamboo	54
ZZ Plant	54
Rubber Plant	52
Calathea Makoyana	51
Monstera	51
Fiddle Leaf Fig	50
Majesty Palm	49
Aloe Vera	49
Devil's Ivy	49
Jade Plant	48
Philodendron	48
Pilea Peperomioides	47
Dragon Tree	47
Spider Plant	47
Money Tree	46
Bird of Paradise	45
Orchid	45
Ficus	43
Birds Nest Fern	42
Pink Anthurium	42
Peace Lily	41
Boston Fern	41
Alocasia Polly	41
Snake Plant	40
Ponytail Palm	40
Angel Wings Begonia	39
Pothos	34

