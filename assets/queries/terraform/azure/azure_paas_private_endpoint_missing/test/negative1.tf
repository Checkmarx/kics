resource "azurerm_mssql_server" "pass_sql" {
  name                         = "sqlpassserver"
  resource_group_name          = "rg"
  location                     = "West Europe"
  version                      = "12.0"
  administrator_login          = "admin"
  administrator_login_password       = "Password123!"
}

resource "azurerm_private_endpoint" "pass_pe" {
  name                = "pe-sql"
  location            = "West Europe"
  resource_group_name = "rg"
  subnet_id           = "subnet-id"

  private_service_connection {
    name                           = "psc-sql"
    private_connection_resource_id = azurerm_mssql_server.pass_sql.id
    is_manual_connection           = false
    subresource_names              = ["sqlServer"]
  }
}