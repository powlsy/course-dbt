{% macro aggregate_events(event_type) %}

    {% set sql %}
        SUM(CASE WHEN event_type = '{{event_type}}' THEN 1 ELSE 0 END)
   {% endset %}

    {% set table = run_query(sql) %}

{% endmacro %}
