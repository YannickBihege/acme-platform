-- dlt unpacks the nested `lines` list into the child table orders__lines
select
    'web-' || l._dlt_id::varchar                         as order_line_id,
    o.id::varchar                                        as order_id,
    o.customer_id::varchar                               as customer_id,
    l.sku::varchar                                       as sku,
    l.quantity::int                                      as quantity,
    (l.unit_price * l.quantity - coalesce(l.discount, 0))::decimal(18,2) as net_amount,
    o.created_at::timestamp                              as ordered_at,
    'webshop'                                            as channel,
    'sale'                                               as line_type
from {{ source('webshop', 'orders__lines') }} as l
join {{ source('webshop', 'orders') }}        as o on l._dlt_parent_id = o._dlt_id
