resource "azurerm_storage_account" "fail_storage" {
  name                     = "storagefail"
  resource_group_name      = "rg"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}