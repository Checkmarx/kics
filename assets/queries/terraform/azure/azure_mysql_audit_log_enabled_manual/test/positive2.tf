resource "azurerm_mysql_flexible_server" "fail_flexible" {
  name                   = "mysql-flex-server-1"
  resource_group_name    = "rg-test"
  location               = "West Europe"
  administrator_login    = "mysqladmin"
  administrator_password = "Password1234!"
}