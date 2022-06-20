How many users do we have?
```
SELECT COUNT(DISTINCT user_id)
FROM dbt_paul_g.stg_users;
```
130


On average, how many orders do we receive per hour?
```
SELECT 
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
```
15.04


On average, how long does an order take from being placed to being delivered?
```
SELECT avg(hours) as avg_time_to_deliv_hrs 
FROM (
SELECT 
  order_id, 
  created_at_utc, 
  delivered_at_utc, 
  (delivered_at_utc - created_at_utc) as days_order_to_deliver,
  (EXTRACT (epoch FROM (delivered_at_utc - created_at_utc)))/3600 as hours
FROM dbt_paul_g.stg_orders
WHERE status='delivered') as time_in_hours
```
93.4 hours 

How many users have only made one purchase? Two purchases? Three+ purchases?

```
SELECT
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
```
  1-One Purchase     25
  2-Two Purchases    28
  3-Three+ Purchases 71


On average, how many unique sessions do we have per hour?

```
with sess_per_hr(unq_sessions, day_hour) AS (
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

SELECT avg(unq_sessions)
FROM sess_per_hr
```
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
