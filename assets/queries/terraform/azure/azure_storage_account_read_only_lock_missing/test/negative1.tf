resource "azurerm_storage_account" "pass" {
  name                     = "stpass"
  resource_group_name      = "rg-test"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_management_lock" "pass_lock" {
  name       = "readonly-lock"
  scope      = azurerm_storage_account.pass.id
  lock_level = "ReadOnly"
}