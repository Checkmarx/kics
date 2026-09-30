# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08  positive-test
resource "azurerm_sql_server" "example" {
  name                         = "kics-test"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "ariel"
  administrator_login_password = "Aa12345678" # positive1

  tags = {
    environment = var.environment
    terragoat   = "true"
  }
}
