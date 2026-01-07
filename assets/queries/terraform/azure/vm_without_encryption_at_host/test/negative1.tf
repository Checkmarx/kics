resource "azurerm_linux_virtual_machine" "negative1" {
  name                = "negative1-machine"
  resource_group_name = azurerm_resource_group.negative1.name
  location            = azurerm_resource_group.negative1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.negative1.id,
  ]

  encryption_at_host_enabled = true
}
