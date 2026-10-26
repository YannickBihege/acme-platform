# Hop project: ERP export

This folder is where your Apache Hop project goes (`pipelines/`, `workflows/`, `metadata/`).
Hop files are created in the Hop GUI, so this repo does not ship them. Build them following
Chapter 12 of the book:

| File | What it does |
| --- | --- |
| `pipelines/extract_orders.hpl` | Table Input (Oracle, filtered by `${WATERMARK}`) -> Select Values -> Add constants (`_extracted_at`) -> Text File Output (`s3://<bucket>/landing/erp/orders/${RUN_DATE}/`) |
| `pipelines/extract_customers.hpl` | Same pattern for customers, products, order lines |
| `workflows/daily_erp_load.hwf` | Start -> extract pipelines -> SQL `COPY INTO RAW.ERP.*` -> success / failure path |

Rules: no secrets in `metadata/`; connections read `${DB_PASSWORD}` and similar from the environment file;
run headless with `hop-run.sh` in a short-lived container; non-zero exit codes fail the scheduler job.
Acceptance check: re-running the same `RUN_DATE` does not duplicate rows in `RAW.ERP`.
