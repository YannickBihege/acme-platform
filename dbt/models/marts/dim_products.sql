select
    md5(sku)          as product_key,
    sku,
    product_name,
    product_category,
    list_price
from {{ ref('stg_erp__products') }}
