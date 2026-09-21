resource "azurerm_linux_virtual_machine_scale_set" "positive3" {
  name                = "positive3-vmss"
  resource_group_name = azurerm_resource_group.positive3.name
  location            = azurerm_resource_group.positive3.location
  sku                 = "Standard_F2"
  instances           = 1
  admin_username      = "adminuser"

  disable_password_authentication = false
}
