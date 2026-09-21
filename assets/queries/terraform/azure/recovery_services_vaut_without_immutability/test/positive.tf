resource "azurerm_recovery_services_vault" "positive1" {
  name                = "positive1-recovery-vault"
  location            = azurerm_resource_group.positive1.location
  resource_group_name = azurerm_resource_group.positive1.name
  sku                 = "Standard"

  # "immutability " missing - defaults to Disabled
}

resource "azurerm_recovery_services_vault" "positive2" {
  name                = "positive2-recovery-vault"
  location            = azurerm_resource_group.positive2.location
  resource_group_name = azurerm_resource_group.positive2.name
  sku                 = "Standard"

  immutability  = "Disabled"
}
