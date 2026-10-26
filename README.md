# acme-platform: companion repository

Companion code for the capstone (Chapter 17) of *The Modern Data Stack on Snowflake: dbt, dlt and Apache Hop*.
The scenario (Acme Outdoor) and all data are invented.

## Run it in 2 minutes, free, on your laptop

```bash
pip install dbt-duckdb "dlt[duckdb]"
make demo            # loads sample CSVs as the raw layer, builds staging -> marts, runs 26 tests + 1 unit test
make dlt             # optional: runs the dlt pipeline into a local DuckDB file
```

Expected: `make demo` finishes with `PASS=45` and one `NO-OP` (the exposure). In dev the web shop freshness
check may warn, because the sample data is old: that is expected.

## What is here

| Folder | Content | Verified |
| --- | --- | --- |
| `dbt/` | Sources, staging, intermediate, marts (star schema), tests, unit test, snapshot, exposure | Runs on DuckDB; Snowflake targets provided in `profiles.yml` |
| `dlt/webshop/` | dlt pipeline with merge + incremental, nested `lines` table | Runs on DuckDB; Snowflake via `secrets.toml.example` |
| `snowflake/` | Roles, warehouses, grants, resource monitor, service users, cost query | Reviewed, not executed here: read before you run |
| `hop/erp/` | Build instructions for the Hop pipelines (Hop files are built in the GUI) | Guide only |
| `orchestration/` | Illustrative Airflow DAG | Illustrative |
| `.github/workflows/` | Slim CI on pull requests | Illustrative: needs your secrets |

## Moving to Snowflake

1. Run `snowflake/01_foundations.sql` and `02_service_users.sql` (after review).
2. Load RAW with Hop (ERP) and dlt (web shop). Do not run `dbt seed` against Snowflake.
3. Set the environment variables used in `dbt/profiles.yml`, then `dbt build --target prod`.
4. Treat the Snowflake run as the source of truth: fix only dialect differences.

## Notes

- The seeds stand in for the raw layer. Source definitions switch table and schema names by target type.
- The customer snapshot (`snapshots/customers_snapshot.yml`) tracks segment changes with the timestamp strategy.
- The `dim_date` model is derived from the facts to keep the demo small; use a calendar table in real projects.

Licence: MIT (add your own LICENSE file before publishing).
