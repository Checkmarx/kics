resource "azurerm_linux_virtual_machine_scale_set" "positive2_1" {
  name                = "positive2_1-vmss"
  resource_group_name = azurerm_resource_group.positive2_1.name
  location            = azurerm_resource_group.positive2_1.location
  sku                 = "Standard_F2"
  instances           = 1
  admin_username      = "adminuser"

  # missing "encryption_at_host_enabled"
}

resource "azurerm_linux_virtual_machine_scale_set" "positive2_2" {
  name                = "positive2_2-vmss"
  resource_group_name = azurerm_resource_group.positive2_2.name
  location            = azurerm_resource_group.positive2_2.location
  sku                 = "Standard_F2"
  instances           = 1
  admin_username      = "adminuser"

  encryption_at_host_enabled = false       # set to false
}
