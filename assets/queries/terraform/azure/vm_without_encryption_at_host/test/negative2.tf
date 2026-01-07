resource "azurerm_linux_virtual_machine_scale_set" "negative2" {
  name                = "negative2-vmss"
  resource_group_name = azurerm_resource_group.negative2.name
  location            = azurerm_resource_group.negative2.location
  sku                 = "Standard_F2"
  instances           = 1
  admin_username      = "adminuser"

  encryption_at_host_enabled = true
}
