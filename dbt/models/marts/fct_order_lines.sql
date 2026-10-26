select
    md5(l.order_line_id)                                  as order_line_key,
    l.order_line_id,
    l.order_id,
    c.customer_key,
    p.product_key,
    cast(extract(year from l.ordered_at) * 10000
       + extract(month from l.ordered_at) * 100
       + extract(day from l.ordered_at) as int)           as date_key,
    l.channel,
    l.line_type,
    l.quantity,
    l.net_amount
from {{ ref('int_order_lines_unioned') }} as l
left join {{ ref('dim_customers') }}      as c on c.customer_id = l.customer_id
left join {{ ref('dim_products') }}       as p on p.sku = l.sku
