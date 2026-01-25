variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "app_name" {
  type = string
}

variable "sql_server_name" {
  type = string
}

variable "sql_admin_login" {
  type = string
}

variable "sql_admin_password" {
  type      = string
  sensitive = true
}

variable "database_name" {
  type    = string
  default = "who_does_what"
}

variable "db_app_user" {
  type    = string
  default = "app"
}

variable "db_app_password" {
  type      = string
  sensitive = true
}

variable "service_plan_sku" {
  type    = string
  default = "B1"
}

variable "odbc_driver" {
  type    = string
  default = "ODBC Driver 18 for SQL Server"
}
