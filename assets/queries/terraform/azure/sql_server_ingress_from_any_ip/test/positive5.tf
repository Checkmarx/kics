resource "azurerm_postgresql_flexible_server_firewall_rule" "example" {
  name = "example-fw"
  server_id        = azurerm_postgresql_flexible_server.example.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}