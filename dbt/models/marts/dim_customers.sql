select
    md5(customer_id)  as customer_key,
    customer_id,
    customer_name,
    customer_segment,
    region
from {{ ref('stg_erp__customers') }}
