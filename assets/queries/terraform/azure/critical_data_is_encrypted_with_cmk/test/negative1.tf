resource "azurerm_storage_account" "example" {
  name                     = "examplestorageacc1"
  resource_group_name      = "example-rg"
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  customer_managed_key {
    key_vault_key_id = "https://example-vault.vault.azure.net/keys/example-key/1234567890abcdef"
  }
}
