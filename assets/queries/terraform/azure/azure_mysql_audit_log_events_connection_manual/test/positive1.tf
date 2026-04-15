resource "azurerm_mysql_flexible_server" "fail" {
  name                   = "mysql-server-connection-fail"
  resource_group_name    = "rg-test"
  location               = "West Europe"
  administrator_login    = "mysqladmin"
  administrator_login_password = "Password1234!"
  sku_name               = "GP_Standard_D2ds_v4"
  version                = "8.0.21"
  # FAIL: No paired azurerm_mysql_flexible_server_configuration for audit_log_events
}
