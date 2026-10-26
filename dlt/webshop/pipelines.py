"""Web shop loader. Runs locally against DuckDB with a built-in sample generator,
and against Snowflake once credentials are configured (see README).

    python pipelines.py                 # DuckDB, sample data, no credentials needed
    DESTINATION=snowflake python pipelines.py   # real destination
"""
import os
from datetime import datetime, timedelta, timezone

import dlt


def sample_orders(since: datetime):
    """Stand-in for the web shop REST API. Replace with dlt's rest_api source."""
    base = datetime(2026, 10, 1, tzinfo=timezone.utc)
    for i in range(1, 21):
        created = base + timedelta(hours=7 * i)
        if created <= since:
            continue
        yield {
            "id": f"W{i:04d}",
            "customer_id": f"C{(i % 60) + 1:03d}",
            "created_at": created,
            "lines": [
                {"sku": "SKU001", "quantity": 1, "unit_price": 189.0, "discount": 0},
                {"sku": "SKU005", "quantity": 2, "unit_price": 59.0, "discount": 5},
            ],
        }


@dlt.resource(name="orders", write_disposition="merge", primary_key="id")
def orders(
    created_at=dlt.sources.incremental("created_at", initial_value=datetime(2000, 1, 1, tzinfo=timezone.utc))
):
    # Nested `lines` becomes the child table orders__lines automatically
    yield from sample_orders(created_at.last_value)


@dlt.source
def webshop():
    return orders()


def run():
    destination = os.getenv("DESTINATION", "duckdb")
    if destination == "duckdb":
        # file name differs from the dataset name to avoid a DuckDB catalog/schema clash
        destination = dlt.destinations.duckdb("local_raw.duckdb")
    pipeline = dlt.pipeline(
        pipeline_name="webshop",
        destination=destination,
        dataset_name="webshop",
    )
    info = pipeline.run(webshop())
    print(info)


if __name__ == "__main__":
    run()
