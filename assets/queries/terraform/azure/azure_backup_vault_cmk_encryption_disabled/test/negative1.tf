resource "azurerm_data_protection_backup_vault" "pass_vault" {
  name                = "backup-vault-secure"
  resource_group_name = "rg-backup"
  location            = "East US"
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_data_protection_backup_vault_customer_managed_key" "pass_cmk" {
  data_protection_backup_vault_id = azurerm_data_protection_backup_vault.pass_vault.id
  key_vault_key_id                = "https://example-kv.vault.azure.net/keys/example-key/version"
}