resource "azurerm_recovery_services_vault" "fail_omission" {
  name                = "fail-vault-omission"
  location            = "West Europe"
  resource_group_name = "rg-test"
  sku                 = "Standard"
  storage_mode_type   = "GeoRedundant"
}