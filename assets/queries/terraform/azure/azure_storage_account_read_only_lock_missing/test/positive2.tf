resource "azurerm_storage_account" "sa_fail_2" {
  name                     = "stfailwronglevel"
  resource_group_name      = "rg-test"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_management_lock" "fail_lock_level" {
  name       = "not-readonly"
  scope      = azurerm_storage_account.sa_fail_2.id
  lock_level = "CanNotDelete"
}