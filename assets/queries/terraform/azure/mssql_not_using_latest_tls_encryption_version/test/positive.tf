resource "azurerm_mssql_server" "positive1" {
  name                         = "example-resource"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "Example-Administrator"
  administrator_login_password = "Example_Password!"
  minimum_tls_version = "1.1"
}