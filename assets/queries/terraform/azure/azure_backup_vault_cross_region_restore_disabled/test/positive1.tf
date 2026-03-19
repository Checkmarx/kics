resource "azurerm_data_protection_backup_vault" "fail_missing" {
  name                = "vault-missing-crr"
  resource_group_name = "rg-test"
  location            = "West Europe"
  datastore_type      = "VaultStore"
  redundancy          = "GeoRedundant"
  # FALLO: Falta cross_region_restore_enabled
}