resource "azurerm_recovery_services_vault" "negative1" {
  name                = "negative1-recovery-vault"
  location            = azurerm_resource_group.negative1.location
  resource_group_name = azurerm_resource_group.negative1.name
  sku                 = "Standard"

  public_network_access_enabled = false
}
