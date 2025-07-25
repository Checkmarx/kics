resource "azurerm_mssql_server" "example" {
  name                         = "my-mssql-server"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "SuperSecurePassword123!"
}


resource "azurerm_mssql_server_security_alert_policy" "negative2" {
  resource_group_name        = azurerm_resource_group.example.name
  server_name                = azurerm_sql_server.example.name
  state                      = "Enabled"
  storage_endpoint           = azurerm_storage_account.example.primary_blob_endpoint
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
  disabled_alerts = []
  retention_days = 20
  email_account_admins = true
}

