resource "azurerm_data_protection_backup_vault" "pass" {
  name                         = "vault-ok"
  resource_group_name          = "rg-test"
  location                     = "West Europe"
  datastore_type               = "VaultStore"
  redundancy                   = "GeoRedundant"

  cross_region_restore_enabled = true
}