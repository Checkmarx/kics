resource "azurerm_recovery_services_vault" "positive1" {
  name                = "positive1-recovery-vault"
  location            = azurerm_resource_group.positive1.location
  resource_group_name = azurerm_resource_group.positive1.name
  sku                 = "Standard"

  # "public_network_access_enabled" missing - defaults to true
}

resource "azurerm_recovery_services_vault" "positive2" {
  name                = "positive2-recovery-vault"
  location            = azurerm_resource_group.positive2.location
  resource_group_name = azurerm_resource_group.positive2.name
  sku                 = "Standard"

  public_network_access_enabled = true
}
