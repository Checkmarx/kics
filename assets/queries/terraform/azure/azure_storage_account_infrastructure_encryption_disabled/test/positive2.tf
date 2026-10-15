resource "azurerm_storage_account" "fail_explicit" {
  name                              = "stfailexplicit"
  resource_group_name               = "rg-test"
  location                          = "West Europe"
  account_tier                      = "Standard"
  account_replication_type          = "LRS"
  infrastructure_encryption_enabled = false
}