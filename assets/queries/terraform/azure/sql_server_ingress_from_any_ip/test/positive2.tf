resource "azurerm_mssql_firewall_rule" "positive1" {
  name              = "FirewallRule1"
  server_id         = azurerm_mssql_server.example.id
  start_ip_address  = "0.0.0.0"
  end_ip_address    = "255.255.255.255"
}
