{% macro event_rank(event_type) %}
   CASE 
   WHEN event_type = 'add_to_cart' THEN 2
   WHEN event_type = 'page_view' THEN 1
   END
{% endmacro %}