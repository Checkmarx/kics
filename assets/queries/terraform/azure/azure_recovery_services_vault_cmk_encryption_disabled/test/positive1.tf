resource "azurerm_recovery_services_vault" "fail" {
  name                = "vault-fail"
  location            = "West Europe"
  resource_group_name = "rg-test"
  sku                 = "Standard"
  # Falla por ausencia de bloque encryption
}