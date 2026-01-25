output "app_hostname" {
  value = azurerm_linux_web_app.main.default_hostname
}

output "sql_server_fqdn" {
  value = azurerm_mssql_server.main.fully_qualified_domain_name
}
