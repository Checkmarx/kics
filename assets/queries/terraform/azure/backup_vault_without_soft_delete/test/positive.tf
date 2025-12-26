resource "azurerm_data_protection_backup_vault" "positive" {
  name                = "positive-backup-vault"
  resource_group_name = azurerm_resource_group.positive.name
  location            = azurerm_resource_group.positive.location
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"

  soft_delete = "off"
}
