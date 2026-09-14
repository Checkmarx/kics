resource "azurerm_recovery_services_vault" "fail_1" {
  name                = "fail-missing-encryption"
  resource_group_name = "rg"
  location            = "West Europe"
  sku                 = "Standard"
}