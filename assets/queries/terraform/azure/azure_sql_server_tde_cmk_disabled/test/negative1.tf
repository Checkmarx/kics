resource "azurerm_mssql_server" "pass" {
  name                         = "sql-server-pass"
  resource_group_name          = "rg-test"
  location                     = "West Europe"
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password       = "Password123!"
}

resource "azurerm_mssql_server_transparent_data_encryption" "pass_tde" {
  server_id        = azurerm_mssql_server.pass.id
  key_vault_key_id = "https://kv.vault.azure.net/keys/key/v1"
}