"""Illustrative Airflow DAG: loaders in parallel, then freshness, then dbt build.
Adapt paths and operators to your environment (Chapter 14.3). Not executed by this repo's tests."""
from datetime import datetime
from airflow import DAG
from airflow.operators.bash import BashOperator

with DAG("acme_daily", start_date=datetime(2026, 10, 1), schedule="0 3 * * *", catchup=False) as dag:
    erp = BashOperator(task_id="erp_extract_load",
                       bash_command="/opt/hop-wrappers/run_erp.sh {{ ds }}")
    web = BashOperator(task_id="webshop_load",
                       bash_command="cd /opt/dlt/webshop && DESTINATION=snowflake python pipelines.py")
    fresh = BashOperator(task_id="dbt_freshness",
                         bash_command="cd /opt/dbt && dbt source freshness --target prod")
    build = BashOperator(task_id="dbt_build",
                         bash_command="cd /opt/dbt && dbt build --target prod")
    [erp, web] >> fresh >> build
