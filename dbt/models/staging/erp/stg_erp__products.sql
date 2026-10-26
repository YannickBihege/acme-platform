select
    product_id::varchar     as sku,
    product_name,
    category                as product_category,
    list_price::decimal(18,2) as list_price
from {{ source('erp', 'products') }}
