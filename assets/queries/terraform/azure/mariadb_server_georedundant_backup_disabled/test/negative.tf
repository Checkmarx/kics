resource "azurerm_mariadb_server" "negative" {
  name                = "example-mariadb-server"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  administrator_login          = "mariadbadmin"
  administrator_login_password = "H@Sh1CoR3!"

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "10.2"

  auto_grow_enabled             = true
  backup_retention_days         = 7
  geo_redundant_backup_enabled  = true
  public_network_access_enabled = false
  ssl_enforcement_enabled       = true
}
