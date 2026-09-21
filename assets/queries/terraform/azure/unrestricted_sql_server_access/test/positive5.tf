resource "azurerm_resource_group" "psqlflex_rg" {
  name     = "example-psqlflex-rg"
  location = "West US"
}

resource "azurerm_postgresql_flexible_server" "psqlflex_server" {
  name                = "examplepsqlflexserver"
  resource_group_name = azurerm_resource_group.psqlflex_rg.name
  location            = azurerm_resource_group.psqlflex_rg.location
  version             = "13"
  administrator_login = "psqlflexadmin"
  administrator_password = "MyS3cureP4ss!"
  sku_name            = "B_Standard_B1ms"
  storage_mb          = 32768
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "psqlflex_fw1" {
  name      = "FirewallRule1"
  server_id = azurerm_postgresql_flexible_server.psqlflex_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "10.0.27.62"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "psqlflex_fw2" {
  name      = "FirewallRule2"
  server_id = azurerm_postgresql_flexible_server.psqlflex_server.id
  start_ip_address = "10.0.17.62"
  end_ip_address   = "10.0.27.62"
}

# Allow access to Azure services (same rule as MSSQL: 0.0.0.0/0)
resource "azurerm_postgresql_flexible_server_firewall_rule" "psqlflex_fw3" {
  name      = "AllowAzure"
  server_id = azurerm_postgresql_flexible_server.psqlflex_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
