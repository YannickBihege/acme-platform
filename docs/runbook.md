# Runbook: first three steps when a run fails

1. Read the failed task log in the scheduler; note which stage failed (load, freshness, build, test).
2. Load failure: check the loader exit code and that RAW row counts are unchanged; safe to re-run the same date.
   Test failure: run `dbt test --select <model>` and inspect the stored failures; do not retry blindly.
3. Tell the owner of the failing source, then re-run from the failed task once the cause is fixed.
