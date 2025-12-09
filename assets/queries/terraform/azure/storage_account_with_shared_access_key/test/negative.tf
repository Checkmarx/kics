resource "azurerm_storage_account" "negative1" {
  name                     = "negative1"
  resource_group_name      = "testRG"
  location                 = "northeurope"
  account_tier             = "Premium"
  account_replication_type = "LRS"
  account_kind             = "FileStorage"

  shared_access_key_enabled = false    # value is set false
}
