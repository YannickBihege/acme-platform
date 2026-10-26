-- One service user per tool and environment, key-pair authentication, no passwords.
use role useradmin;
create user if not exists svc_dbt_prod
  default_role = transformer default_warehouse = transform_wh
  type = service rsa_public_key = '<paste public key body>';
create user if not exists svc_dlt_prod
  default_role = loader default_warehouse = loading_wh
  type = service rsa_public_key = '<paste public key body>';

use role securityadmin;
grant role transformer to user svc_dbt_prod;
grant role loader to user svc_dlt_prod;

-- Make every query attributable
alter user svc_dbt_prod set query_tag = 'dbt_prod';
alter user svc_dlt_prod set query_tag = 'dlt_prod';
