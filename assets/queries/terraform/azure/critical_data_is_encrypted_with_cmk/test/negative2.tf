resource "azurerm_storage_account" "example" {
  name                     = "examplestorageacc2"
  resource_group_name      = "example-rg"
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account_customer_managed_key" "example" {
  storage_account_id = azurerm_storage_account.example.id
  key_vault_id       = "https://example-vault.vault.azure.net/"
  key_name           = "example-key"
  key_version        = "1234567890abcdef"
}
