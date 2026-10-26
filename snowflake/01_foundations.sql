-- Foundations for the Acme platform (Chapter 2). Run as a role that can create roles and warehouses.
-- Adjust names to your conventions. Review before running.

use role useradmin;
create role if not exists loader;
create role if not exists transformer;
create role if not exists analyst;

use role sysadmin;
create database if not exists raw;
create database if not exists analytics;
create schema if not exists raw.erp;
create schema if not exists raw.webshop;
create schema if not exists analytics.marts;

create warehouse if not exists loading_wh
  warehouse_size = 'XSMALL' auto_suspend = 60 auto_resume = true initially_suspended = true;
create warehouse if not exists transform_wh
  warehouse_size = 'SMALL' auto_suspend = 60 auto_resume = true initially_suspended = true;

use role securityadmin;

-- Loaders write RAW
grant usage on database raw to role loader;
grant usage, create table on schema raw.erp to role loader;
grant usage, create table on schema raw.webshop to role loader;
grant select, insert, update, delete on future tables in schema raw.erp to role loader;
grant select, insert, update, delete on future tables in schema raw.webshop to role loader;
grant usage on warehouse loading_wh to role loader;

-- dbt reads RAW and owns ANALYTICS
grant usage on database raw to role transformer;
grant usage on all schemas in database raw to role transformer;
grant usage on future schemas in database raw to role transformer;
grant select on all tables in schema raw.erp to role transformer;
grant select on future tables in schema raw.erp to role transformer;
grant select on all tables in schema raw.webshop to role transformer;
grant select on future tables in schema raw.webshop to role transformer;
grant all on database analytics to role transformer;
grant usage on warehouse transform_wh to role transformer;

-- Analysts read marts
grant usage on database analytics to role analyst;
grant usage on schema analytics.marts to role analyst;
grant select on future tables in schema analytics.marts to role analyst;
grant select on future views in schema analytics.marts to role analyst;
grant usage on warehouse transform_wh to role analyst;

-- Role hierarchy: SYSADMIN sees everything the functional roles own
grant role loader to role sysadmin;
grant role transformer to role sysadmin;
grant role analyst to role sysadmin;

-- Cost guard rail
use role accountadmin;
create resource monitor if not exists acme_monthly
  with credit_quota = 100 frequency = monthly start_timestamp = immediately
  triggers on 80 percent do notify
           on 100 percent do suspend;
alter warehouse loading_wh set resource_monitor = acme_monthly;
alter warehouse transform_wh set resource_monitor = acme_monthly;
