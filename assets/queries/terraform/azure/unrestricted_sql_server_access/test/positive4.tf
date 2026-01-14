resource "azurerm_resource_group" "psql_rg" {
  name     = "example-postgres-rg"
  location = "West US"
}

resource "azurerm_postgresql_server" "psql_server" {
  name                = "examplepostgresqlserver"
  location            = azurerm_resource_group.psql_rg.location
  resource_group_name = azurerm_resource_group.psql_rg.name
  administrator_login = "psqladmin"
  sku_name            = "B_Gen5_2"
  storage_mb          = 5120
  version             = "11"
  auto_grow_enabled   = true
  backup_retention_days = 7
  geo_redundant_backup_enabled = false
  ssl_enforcement_enabled = true
}

resource "azurerm_postgresql_firewall_rule" "psql_fw1" {
  name                = "FirewallRule1"
  resource_group_name = azurerm_resource_group.psql_rg.name
  server_name         = azurerm_postgresql_server.psql_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "10.0.27.62"
}

resource "azurerm_postgresql_firewall_rule" "psql_fw2" {
  name                = "FirewallRule2"
  resource_group_name = azurerm_resource_group.psql_rg.name
  server_name         = azurerm_postgresql_server.psql_server.name
  start_ip_address    = "10.0.17.62"
  end_ip_address      = "10.0.27.62"
}

# Allow access to Azure services
resource "azurerm_postgresql_firewall_rule" "psql_fw3" {
  name                = "AllowAzure"
  resource_group_name = azurerm_resource_group.psql_rg.name
  server_name         = azurerm_postgresql_server.psql_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
