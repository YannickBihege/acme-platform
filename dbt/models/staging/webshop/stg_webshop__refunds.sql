-- Refunds become negative lines so that sums are correct
select
    'refund-' || r.refund_id::varchar                    as order_line_id,
    r.order_id::varchar                                  as order_id,
    o.customer_id::varchar                               as customer_id,
    r.sku::varchar                                       as sku,
    -r.quantity::int                                     as quantity,
    -r.amount::decimal(18,2)                             as net_amount,
    r.created_at::timestamp                              as ordered_at,
    'webshop'                                            as channel,
    'refund'                                             as line_type
from {{ source('webshop', 'refunds') }} as r
join {{ source('webshop', 'orders') }}  as o on o.id = r.order_id
