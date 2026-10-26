-- Singular test: the fact table must hold exactly the sum of the unioned lines
select 1
from (
    select (select sum(net_amount) from {{ ref('fct_order_lines') }}) as fct_total,
           (select sum(net_amount) from {{ ref('int_order_lines_unioned') }}) as src_total
) t
where fct_total <> src_total
