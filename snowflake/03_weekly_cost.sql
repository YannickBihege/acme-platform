-- Credits per warehouse over the last 7 days (needs access to SNOWFLAKE.ACCOUNT_USAGE)
select warehouse_name, round(sum(credits_used), 2) as credits
from snowflake.account_usage.warehouse_metering_history
where start_time >= dateadd(day, -7, current_timestamp())
group by 1
order by 2 desc;
