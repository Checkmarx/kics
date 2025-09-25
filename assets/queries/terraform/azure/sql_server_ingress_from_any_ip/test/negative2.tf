resource "azurerm_mssql_firewall_rule" "negative1" {
  name              = "FirewallRule1"
  server_id         = azurerm_mssql_server.example.id
  start_ip_address  = "10.0.17.62"
  end_ip_address    = "10.0.17.62"
}
