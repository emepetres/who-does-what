terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_mssql_server" "main" {
  name                         = var.sql_server_name
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
}

resource "azurerm_mssql_database" "main" {
  name           = var.database_name
  server_id      = azurerm_mssql_server.main.id
  sku_name       = "S0"
  zone_redundant = false
}

resource "azurerm_mssql_firewall_rule" "allow_azure" {
  name             = "allow-azure-services"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_service_plan" "main" {
  name                = "${var.app_name}-plan"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = var.service_plan_sku
}

locals {
  db_host      = "${azurerm_mssql_server.main.name}.database.windows.net"
  database_url = "mssql+pyodbc://${var.db_app_user}:${var.db_app_password}@${local.db_host}:1433/${azurerm_mssql_database.main.name}?driver=${urlencode(var.odbc_driver)}&Encrypt=yes&TrustServerCertificate=no"
}

resource "azurerm_linux_web_app" "main" {
  name                = var.app_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true

  site_config {
    application_stack {
      python_version = "3.12"
    }
  }

  app_settings = {
    DATABASE_URL                   = local.database_url
    DB_NAME                        = azurerm_mssql_database.main.name
    DB_APP_USER                    = var.db_app_user
    DB_APP_PASSWORD                = var.db_app_password
    MSSQL_HOST                      = local.db_host
    MSSQL_PORT                      = "1433"
    MSSQL_DRIVER                    = var.odbc_driver
    MSSQL_ENCRYPT                   = "true"
    MSSQL_TRUST_SERVER_CERTIFICATE  = "false"
  }
}
