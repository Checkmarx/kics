resource "azurerm_mariadb_firewall_rule" "example" {
  name                = "test-rule"
  server_name         = "test-server"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}