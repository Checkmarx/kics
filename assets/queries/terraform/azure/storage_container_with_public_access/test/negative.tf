resource "azurerm_storage_container" "negative1" {
  name                  = "vhds"
  storage_account_name  = azurerm_storage_account.example.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "negative2" {
  name                  = "vhds2"
  storage_account_name  = azurerm_storage_account.example.name
  // default is "private"
}