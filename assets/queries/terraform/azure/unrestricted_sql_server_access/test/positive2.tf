resource "azurerm_resource_group" "positive1" {
  name     = "acceptanceTestResourceGroup1"
  location = "West US"
}

resource "azurerm_mssql_server" "positive2" {
  name                         = "mysqlserver"
  resource_group_name          = azurerm_resource_group.positive1.name
  location                     = azurerm_resource_group.positive1.location
  version                      = "12.0"
  administrator_login          = "4dm1n157r470r"
  administrator_login_password = "4-v3ry-53cr37-p455w0rd"
  minimum_tls_version          = "1.2"
}

resource "azurerm_mssql_firewall_rule" "positive3" {
  name              = "FirewallRule1"
  server_id         = azurerm_mssql_server.positive2.id
  start_ip_address  = "0.0.0.0"
  end_ip_address    = "10.0.27.62"
}

resource "azurerm_mssql_firewall_rule" "positive4" {
  name              = "FirewallRule2"
  server_id         = azurerm_mssql_server.positive2.id
  start_ip_address  = "10.0.17.62"
  end_ip_address    = "10.0.27.62"
}

# Azure feature "Allow access to Azure services"
resource "azurerm_mssql_firewall_rule" "positive5" {
  server_id         = azurerm_mssql_server.example.id
  start_ip_address  = "0.0.0.0"
  end_ip_address    = "0.0.0.0"
}

