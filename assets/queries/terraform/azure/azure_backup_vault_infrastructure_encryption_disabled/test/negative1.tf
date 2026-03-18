resource "azurerm_data_protection_backup_vault" "pass" {
  name                = "vault-with-identity"
  resource_group_name = "rg"
  location            = "West Europe"
  datastore_type      = "VaultStore"
  redundancy          = "LocallyRedundant"

  identity {
    type = "SystemAssigned"
  }
}