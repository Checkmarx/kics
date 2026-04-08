resource "azurerm_data_protection_backup_vault" "negative1" {
  name                = "negative1-backup-vault"
  resource_group_name = azurerm_resource_group.negative1.name
  location            = azurerm_resource_group.negative1.location
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"

  immutability = "Unlocked"
}

resource "azurerm_data_protection_backup_vault" "negative2" {
  name                = "negative2-backup-vault"
  resource_group_name = azurerm_resource_group.negative2.name
  location            = azurerm_resource_group.negative2.location
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"

  immutability = "Locked"
}
