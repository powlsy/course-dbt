{% macro grant(schema, role) %}

    grant usage on schema {{ schema }} to group {{ role }};
    grant select on all tables in schema {{ schema }} to group {{ role }};
{% endmacro %}