resource "azurerm_data_protection_backup_vault" "fail_vault" {
  name                = "backup-vault-insecure"
  resource_group_name = "rg-backup"
  location            = "East US"
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"

  identity {
    type = "SystemAssigned"
  }
}