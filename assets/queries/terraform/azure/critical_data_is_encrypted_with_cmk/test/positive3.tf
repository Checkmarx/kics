resource "azurerm_storage_account" "main" {
  name                     = "examplestorageacc5"
  resource_group_name      = "example-rg"
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account_customer_managed_key" "positive3" {
  storage_account_id = azurerm_storage_account.not_main.id
  key_vault_id       = "https://example-vault.vault.azure.net/"
  key_name           = "example-key"
  key_version        = "1234567890abcdef"
}
