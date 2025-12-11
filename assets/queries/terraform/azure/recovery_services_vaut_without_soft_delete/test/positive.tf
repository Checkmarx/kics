resource "azurerm_recovery_services_vault" "positive" {
  name                = "positive-recovery-vault"
  location            = azurerm_resource_group.positive.location
  resource_group_name = azurerm_resource_group.positive.name
  sku                 = "Standard"

  soft_delete_enabled = false
}
