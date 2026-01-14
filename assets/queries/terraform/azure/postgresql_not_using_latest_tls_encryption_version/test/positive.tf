resource "azurerm_postgresql_server" "negative2" {
  name                = "example-psqlserver"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku_name   = "GP_Gen5_4"
  version    = "11"

  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_1"
}