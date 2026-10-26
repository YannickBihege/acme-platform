select
    customer_id::varchar   as customer_id,
    name                   as customer_name,
    segment                as customer_segment,
    region                 as region,
    updated_at::timestamp  as updated_at
from {{ source('erp', 'customers') }}
