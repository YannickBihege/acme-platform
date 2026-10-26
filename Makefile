.PHONY: demo seed build test clean dlt
export DBT_PROFILES_DIR := ./dbt

demo: seed build        ## local run on DuckDB, no cloud account needed

seed:
	cd dbt && DBT_PROFILES_DIR=. dbt seed
build:
	cd dbt && DBT_PROFILES_DIR=. dbt build
test:
	cd dbt && DBT_PROFILES_DIR=. dbt test
dlt:
	cd dlt/webshop && python pipelines.py
clean:
	rm -rf dbt/target dbt/logs dbt/*.duckdb* dlt/webshop/local_raw.duckdb*
