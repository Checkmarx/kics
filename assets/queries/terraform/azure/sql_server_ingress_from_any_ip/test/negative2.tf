resource "azurerm_mssql_firewall_rule" "negative1-1" {
  name              = "FirewallRule1"
  server_id         = azurerm_mssql_server.example.id
  start_ip_address  = "10.0.17.62"
  end_ip_address    = "10.0.17.62"
}

resource "azurerm_mssql_firewall_rule" "negative1-2" {
  name              = "FirewallRule1"
  server_id         = azurerm_mssql_server.example.id
  start_ip_address  = "10.0.17.62"
  end_ip_address    = "255.255.255.255"
}

resource "azurerm_mssql_firewall_rule" "negative1-3" {
  name              = "FirewallRule1"
  server_id         = azurerm_mssql_server.example.id
  start_ip_address  = "0.0.0.0"
  end_ip_address    = "10.0.17.62"
}