resource "azurerm_resource_group" "psqlflex_negative_rg" {
  name     = "acceptanceTestResourceGroup1"
  location = "West US"
}

resource "azurerm_postgresql_flexible_server" "psqlflex_negative_server" {
  name                   = "negativepsqlflexserver"
  resource_group_name    = azurerm_resource_group.psqlflex_negative_rg.name
  location               = azurerm_resource_group.psqlflex_negative_rg.location
  version                = "13"
  administrator_login    = "psqlflexadmin"
  administrator_password = "MyS3cureP4ss!"
  sku_name               = "B_Standard_B1ms"
  storage_mb             = 32768
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "psqlflex_negative_fw" {
  name             = "FirewallRule1"
  server_id        = azurerm_postgresql_flexible_server.psqlflex_negative_server.id
  start_ip_address = "10.0.17.62"
  end_ip_address   = "10.0.17.62"
}