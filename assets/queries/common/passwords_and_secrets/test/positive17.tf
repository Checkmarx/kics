resource "azurerm_sql_server" "example" {
  name                         = "kics-test"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "ariel"
  administrator_login_password = "Aa12345678"

  tags = {
    environment = var.environment
    terragoat   = "true"
  }
}
