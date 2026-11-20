# PASS: LocallyRedundant vault — cross_region_restore_enabled is not applicable
resource "azurerm_data_protection_backup_vault" "pass_local_redundant" {
  name                = "vault-local-redundant"
  resource_group_name = "rg-test"
  location            = "West Europe"
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"
}
