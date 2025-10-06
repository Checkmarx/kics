resource "azurerm_storage_account_customer_managed_key" "orphan" {
  storage_account_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.Storage/storageAccounts/nonexistentaccount"
  key_vault_id       = "https://example-vault.vault.azure.net/"
  key_name           = "example-key"
  key_version        = "1234567890abcdef"
}