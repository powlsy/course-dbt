{{
    config(
        materialized = 'table' 
    )
}}


with intermediate as (
    SELECT
    user_session.session_id
    , user_session.user_id
    , events.product_id
    , MAX({{event_rank('events.event_type')}}) as event_rank
    FROM {{ref('stg_events')}} as events
    LEFT JOIN {{ref('fact_user_session')}} as user_session
    USING (session_id)
    WHERE product_id is not null
    GROUP BY 1, 2, 3
)

SELECT * from intermediate