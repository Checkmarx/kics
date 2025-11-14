resource "azurerm_recovery_services_vault" "negative1" {
  name                = "negative1-recovery-vault"
  location            = azurerm_resource_group.negative1.location
  resource_group_name = azurerm_resource_group.negative1.name
  sku                 = "Standard"

  immutability  = "Locked"
}

resource "azurerm_recovery_services_vault" "negative2" {
  name                = "negative2-recovery-vault"
  location            = azurerm_resource_group.negative2.location
  resource_group_name = azurerm_resource_group.negative2.name
  sku                 = "Standard"

  immutability  = "Unlocked"
}
