resource "azurerm_storage_account" "fail_missing_block" {
  name                     = "stfailblock"
  resource_group_name      = "rg-test"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}