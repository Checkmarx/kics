resource "azurerm_recovery_services_vault" "fail_explicit" {
  name                         = "fail-vault-explicit"
  location                     = "West Europe"
  resource_group_name          = "rg-test"
  sku                          = "Standard"
  storage_mode_type            = "GeoRedundant"
  cross_region_restore_enabled = false
}