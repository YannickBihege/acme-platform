-- Built from the dates that occur in the facts; swap for a calendar table in real projects
with days as (
    select distinct cast(ordered_at as date) as date_day
    from {{ ref('int_order_lines_unioned') }}
)
select
    cast(extract(year from date_day) * 10000 + extract(month from date_day) * 100 + extract(day from date_day) as int) as date_key,
    date_day,
    extract(year from date_day)    as year_number,
    extract(month from date_day)   as month_number,
    extract(quarter from date_day) as quarter_number
from days
