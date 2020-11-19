resource "azurerm_storage_container" "example" {
  name                  = "vhds"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "example2" {
  name                  = "vhds2"
  storage_account_name  = azurerm_storage_account.example.name
  // default is "private"
}