resource "azurerm_mssql_server" "fail_single" {
  name                = "mysql-server-1"
  resource_group_name = "rg-test"
  location            = "West Europe"
  administrator_login    = "mysqladmin"
  administrator_login_password = "Password1234!"
  version             = "5.7"
}