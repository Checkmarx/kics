resource "azurerm_postgresql_flexible_server_firewall_rule" "negative5-1" {
  name = "example-fw"
  server_id        = azurerm_postgresql_flexible_server.example.id
  start_ip_address    = "10.0.17.62"
  end_ip_address      = "10.0.17.62"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "negative5-2" {
  name = "example-fw"
  server_id        = azurerm_postgresql_flexible_server.example.id
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "10.0.17.62"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "negative5-3" {
  name = "example-fw"
  server_id        = azurerm_postgresql_flexible_server.example.id
  start_ip_address    = "10.0.17.62"
  end_ip_address      = "255.255.255.255"
}