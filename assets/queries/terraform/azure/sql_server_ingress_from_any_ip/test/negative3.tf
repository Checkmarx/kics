resource "azurerm_mariadb_firewall_rule" "negative3-1" {
  name                = "test-rule"
  server_name         = "test-server"
  start_ip_address    = "10.0.17.62"
  end_ip_address      = "10.0.17.62"
}

resource "azurerm_mariadb_firewall_rule" "negative3-2" {
  name                = "test-rule"
  server_name         = "test-server"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "10.0.17.62"
}

resource "azurerm_mariadb_firewall_rule" "negative3-3" {
  name                = "test-rule"
  server_name         = "test-server"
  start_ip_address    = "10.0.17.62"
  end_ip_address      = "255.255.255"
}