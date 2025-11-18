resource "azurerm_data_protection_backup_vault" "positive1" {
  name                = "positive1-backup-vault"
  resource_group_name = azurerm_resource_group.positive1.name
  location            = azurerm_resource_group.positive1.location
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"

  # missing immutability - defaults to Disabled
}

resource "azurerm_data_protection_backup_vault" "positive2" {
  name                = "positive2-backup-vault"
  resource_group_name = azurerm_resource_group.positive2.name
  location            = azurerm_resource_group.positive2.location
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"

  immutability = "Disabled"
}
