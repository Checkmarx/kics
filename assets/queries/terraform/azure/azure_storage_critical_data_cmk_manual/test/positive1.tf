resource "azurerm_storage_account" "fail_1" {
  name                     = "st-no-cmk-block"
  resource_group_name      = "rg"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}