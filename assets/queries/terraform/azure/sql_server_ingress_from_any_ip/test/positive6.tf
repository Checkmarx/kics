resource "azurerm_mysql_flexible_server_firewall_rule" "example" {
  name                = "office"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_mysql_flexible_server.example.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}