# PASS: LocallyRedundant vault — cross_region_restore_enabled is not applicable
resource "azurerm_recovery_services_vault" "pass_local" {
  name                = "pass-vault-local"
  location            = "West Europe"
  resource_group_name = "rg-test"
  sku                 = "Standard"
  storage_mode_type   = "LocallyRedundant"
}
