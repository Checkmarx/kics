resource "azurerm_resource_group" "mysqlflex_rg" {
  name     = "example-mysqlflex-rg"
  location = "West US"
}

resource "azurerm_mysql_flexible_server" "mysqlflex_server" {
  name                = "examplemysqlflexserver"
  resource_group_name = azurerm_resource_group.mysqlflex_rg.name
  location            = azurerm_resource_group.mysqlflex_rg.location
  version             = "8.0.21"
  administrator_login = "mysqlflexadmin"
  administrator_password = "MyS3cureP4ss!"
  sku_name            = "B_Standard_B1ms"
  storage_mb          = 32768
}

resource "azurerm_mysql_flexible_server_firewall_rule" "mysqlflex_fw1" {
  name      = "FirewallRule1"
  server_id = azurerm_mysql_flexible_server.mysqlflex_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "10.0.27.62"
}

resource "azurerm_mysql_flexible_server_firewall_rule" "mysqlflex_fw2" {
  name      = "FirewallRule2"
  server_id = azurerm_mysql_flexible_server.mysqlflex_server.id
  start_ip_address = "10.0.17.62"
  end_ip_address   = "10.0.27.62"
}

# Allow access to Azure services
resource "azurerm_mysql_flexible_server_firewall_rule" "mysqlflex_fw3" {
  name      = "AllowAzure"
  server_id = azurerm_mysql_flexible_server.mysqlflex_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}