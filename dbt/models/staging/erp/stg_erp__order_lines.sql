select
    'erp-' || l.line_id::varchar                         as order_line_id,
    l.order_id::varchar                                  as order_id,
    o.customer_id::varchar                               as customer_id,
    l.sku::varchar                                       as sku,
    l.quantity::int                                      as quantity,
    (l.unit_price * l.quantity - coalesce(l.discount, 0))::decimal(18,2) as net_amount,
    o.ordered_at::timestamp                              as ordered_at,
    'erp'                                                as channel,
    'sale'                                               as line_type
from {{ source('erp', 'order_lines') }} as l
join {{ source('erp', 'orders') }}      as o on o.order_id = l.order_id
where o.status <> 'cancelled'
