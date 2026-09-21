resource "azurerm_resource_group" "mariadb_rg" {
  name     = "example-mariadb-rg"
  location = "West US"
}

resource "azurerm_mariadb_server" "mariadb_server" {
  name                = "examplemariadbserver"
  location            = azurerm_resource_group.mariadb_rg.location
  resource_group_name = azurerm_resource_group.mariadb_rg.name
  administrator_login = "mariadbadmin"
  administrator_login_password = "MyS3cureP4ss!"
  sku_name            = "B_Gen5_2"
  storage_mb          = 5120
  version             = "10.2"
  auto_grow_enabled   = true
  backup_retention_days = 7
  geo_redundant_backup_enabled = false
  ssl_enforcement_enabled = true
}

resource "azurerm_mariadb_firewall_rule" "mariadb_fw1" {
  name                = "FirewallRule1"
  resource_group_name = azurerm_resource_group.mariadb_rg.name
  server_name         = azurerm_mariadb_server.mariadb_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "10.0.27.62"
}

resource "azurerm_mariadb_firewall_rule" "mariadb_fw2" {
  name                = "FirewallRule2"
  resource_group_name = azurerm_resource_group.mariadb_rg.name
  server_name         = azurerm_mariadb_server.mariadb_server.name
  start_ip_address    = "10.0.17.62"
  end_ip_address      = "10.0.27.62"
}

resource "azurerm_mariadb_firewall_rule" "mariadb_fw3" {
  name                = "AllowAzure"
  resource_group_name = azurerm_resource_group.mariadb_rg.name
  server_name         = azurerm_mariadb_server.mariadb_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}