resource "azurerm_storage_account" "no_mysql_here" {
  name                     = "storageaccountneg1"
  resource_group_name      = "rg-test"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
