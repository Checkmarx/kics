resource "azurerm_mssql_server" "fail" {
  name                         = "sql-server-fail"
  resource_group_name          = "rg-test"
  location                     = "West Europe"
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password       = "Password123!"
}