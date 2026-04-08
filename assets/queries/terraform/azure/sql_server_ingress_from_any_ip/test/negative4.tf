resource "azurerm_postgresql_firewall_rule" "negative4-1" {
  name     = "office"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_postgresql_server.example.name
  start_ip_address    = "10.0.17.62"
  end_ip_address      = "10.0.17.62"
}

resource "azurerm_postgresql_firewall_rule" "negative4-2" {
  name     = "office"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_postgresql_server.example.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "10.0.17.62"
}

resource "azurerm_postgresql_firewall_rule" "negative4-3" {
  name     = "office"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_postgresql_server.example.name
  start_ip_address    = "10.0.17.62"
  end_ip_address      = "255.255.255"
}