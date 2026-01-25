# Who Does What API

## Local development

- Use the devcontainer and `backend/docker-compose.yml` to start SQL Server.
- Set these environment variables in `.env` (or your shell):
  - `DB_APP_PASSWORD` (required unless `DATABASE_URL` is set)
  - `MSSQL_SA_PASSWORD` (required for init script)
- Initialize the database and app user:
  - `./devtools/db/init-db.sh`
- Smoke check the connection:
  - `./devtools/db/smoke-check.sh`

## Database configuration

The app reads `DATABASE_URL` first. If it is not set, it composes a URL from:
`MSSQL_HOST`, `MSSQL_PORT`, `DB_NAME`, `DB_APP_USER`, `DB_APP_PASSWORD`.

## Migrations (Alembic)

- Create a migration:
  - `make db-revision name="init_schema"`
- Apply migrations:
  - `make db-upgrade`

Both commands run through `uv` and use the same settings as the app.

## Terraform (Azure SQL + App Service)

Terraform configuration lives in `backend/infra`.

Required inputs (example `terraform.tfvars`):

```
resource_group_name = "who-does-what-rg"
location            = "eastus"
app_name            = "who-does-what-api"
sql_server_name     = "who-does-what-sql"
sql_admin_login     = "sqladmin"
sql_admin_password  = "replace-me"
db_app_password     = "replace-me"
```

Typical local flow:

```
cd backend/infra
terraform init
terraform plan
terraform apply
```

For CI, provide standard Azure credentials (`ARM_CLIENT_ID`, `ARM_CLIENT_SECRET`,
`ARM_SUBSCRIPTION_ID`, `ARM_TENANT_ID`) and run the same Terraform commands.

Note: the Terraform config wires `DATABASE_URL` and related app settings, but it does
not create the application database user. Create that user via SQL or a migration.
Also ensure the App Service runtime has the SQL Server ODBC driver available if you
deploy without a custom container image.
