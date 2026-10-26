# Source register

| Source | System | Loader | Schedule | RAW location | Owner | Freshness SLA |
| --- | --- | --- | --- | --- | --- | --- |
| ERP | Oracle | Apache Hop | daily | RAW.ERP | Data platform team | 26 h |
| Web shop | REST API | dlt | hourly | RAW.WEBSHOP | Data platform team | 3 h |

Adding a source: register it here, land it untouched in RAW, add a `_<source>__sources.yml` with freshness,
one staging model per table with a tested primary key, then extend the intermediate model.
