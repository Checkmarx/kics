resource "azurerm_data_protection_backup_vault" "fail" {
  name                = "vault-no-identity"
  resource_group_name = "rg"
  location            = "West Europe"
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"
  # FALLO: No tiene bloque identity
}