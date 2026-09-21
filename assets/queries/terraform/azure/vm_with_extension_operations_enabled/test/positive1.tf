resource "azurerm_linux_virtual_machine" "positive1_1" {
  name                = "positive1_1-machine"
  resource_group_name = azurerm_resource_group.positive1_1.name
  location            = azurerm_resource_group.positive1_1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.positive1_1.id,
  ]

  # missing "allow_extension_operations"
}

resource "azurerm_linux_virtual_machine" "positive1_2" {
  name                = "positive1_2-machine"
  resource_group_name = azurerm_resource_group.positive1_2.name
  location            = azurerm_resource_group.positive1_2.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.positive1_2.id,
  ]

  allow_extension_operations = true     # set to true
}
