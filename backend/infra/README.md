# Infrastructure (Azure)

This Terraform config deploys:
- Azure Resource Group
- Azure SQL Server + Database (S0) with firewall rule for Azure services
- App Service Plan (Linux)
- Linux Web App configured for Python 3.12 with DB environment variables

Outputs:
- `app_hostname`
- `sql_server_fqdn`

## Prerequisites

- Terraform >= 1.5
- Azure CLI (`az`)
- An Azure Storage Account + container for Terraform state

## Configure remote state (`backend.hcl`)

Create `backend.hcl` (gitignored). Example:

```
resource_group_name  = "who-does-what-tfstate-rg"
storage_account_name = "whodoeswhattfstate"
container_name       = "tfstate"
key                  = "who-does-what/infra.tfstate"
```

Before running terraform for the first time, you need to create the state storage resources, a minimal Azure CLI flow is:

```
az group create --name who-does-what-tfstate-rg --location westeurope
az storage account create --name whodoeswhattfstate --resource-group who-does-what-tfstate-rg --location westeurope --sku Standard_LRS
az storage container create --name tfstate --account-name whodoeswhattfstate
```

## Configure inputs (`terraform.tfvars`)

Create `terraform.tfvars` (gitignored). Example:

```
resource_group_name = "who-does-what-rg"
location            = "westeurope"            # default: westeurope
app_name            = "who-does-what-api"
sql_server_name     = "who-does-what-sql"
sql_admin_login     = "sqladmin"
sql_admin_password  = "replace-me"            # required

db_app_user         = "app"                   # default: app
db_app_password     = "replace-me"            # required

database_name       = "who_does_what"         # default: who_does_what
service_plan_sku    = "B1"                    # default: B1
odbc_driver         = "ODBC Driver 18 for SQL Server"  # default
```

Required inputs:
- `resource_group_name`
- `app_name`
- `sql_server_name`
- `sql_admin_login`
- `sql_admin_password`
- `db_app_password`

Optional inputs with defaults:
- `location` (default `westeurope`)
- `database_name` (default `who_does_what`)
- `db_app_user` (default `app`)
- `service_plan_sku` (default `B1`)
- `odbc_driver` (default `ODBC Driver 18 for SQL Server`)

## Local deploy (Azure CLI)

```
cd backend/infra
az login
az account set --subscription "<subscription-id>"
terraform init -backend-config=backend.hcl
terraform plan
terraform apply
```

## CI/CD (GitHub Actions)

Workflow: `.github/workflows/infra.deploy.yml`

Secrets:
- `AZURE_CLIENT_ID`
- `AZURE_CLIENT_SECRET`
- `AZURE_SUBSCRIPTION_ID`
- `AZURE_TENANT_ID`
- `AZURE_SQL_ADMIN_PASSWORD`
- `AZURE_DB_APP_PASSWORD`

Variables (example/default values shown where optional):
- `TFSTATE_RESOURCE_GROUP` (e.g. `who-does-what-tfstate-rg`)
- `TFSTATE_STORAGE_ACCOUNT` (e.g. `whodoeswhattfstate`)
- `TFSTATE_CONTAINER` (e.g. `tfstate`)
- `TFSTATE_KEY` (e.g. `who-does-what/infra.tfstate`)
- `AZURE_RESOURCE_GROUP` (e.g. `who-does-what-rg`)
- `AZURE_LOCATION` (default `westeurope`)
- `AZURE_APP_NAME` (e.g. `who-does-what-api`)
- `AZURE_SQL_SERVER_NAME` (e.g. `who-does-what-sql`)
- `AZURE_SQL_ADMIN_LOGIN` (e.g. `sqladmin`)
- `AZURE_DB_APP_USER` (default `app`)
- `AZURE_SERVICE_PLAN_SKU` (default `B1`)
- `AZURE_ODBC_DRIVER` (default `ODBC Driver 18 for SQL Server`)
