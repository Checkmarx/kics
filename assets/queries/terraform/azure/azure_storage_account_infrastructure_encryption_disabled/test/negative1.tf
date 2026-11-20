resource "azurerm_storage_account" "pass" {
  name                              = "stpass"
  resource_group_name               = "rg-test"
  location                          = "West Europe"
  account_tier                      = "Standard"
  account_replication_type          = "LRS"
  infrastructure_encryption_enabled = true
}