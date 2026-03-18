resource "azurerm_storage_account" "fail_explicit_false" {
  name                     = "stfailexplicit"
  resource_group_name      = "rg-test"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  blob_properties {
    versioning_enabled = false
  }
}