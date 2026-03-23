resource "azurerm_storage_account" "no_rg_here" {
  name                     = "storageaccountneg1"
  resource_group_name      = "rg-existing"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
