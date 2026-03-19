resource "azurerm_data_protection_backup_vault" "fail_explicit" {
  name                         = "vault-disabled-crr"
  resource_group_name          = "rg-test"
  location                     = "West Europe"
  datastore_type               = "VaultStore"
  redundancy                   = "GeoRedundant"
  
  cross_region_restore_enabled = false # FALLO
}