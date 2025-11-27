resource "azurerm_linux_virtual_machine" "positive1" {
  name                = "positive1-machine"
  resource_group_name = azurerm_resource_group.positive1.name
  location            = azurerm_resource_group.positive1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.positive1.id,
  ]

  # missing "admin_ssh_key"
}

resource "azurerm_linux_virtual_machine" "positive2" {
  name                = "positive2-machine"
  resource_group_name = azurerm_resource_group.positive2.name
  location            = azurerm_resource_group.positive2.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.positive2.id,
  ]

  admin_ssh_key {                                   # single ssh key
    username   = "adminuser"
    # missing "public_key" (tecnically required)
  }
}

resource "azurerm_linux_virtual_machine" "positive3" {
  name                = "positive3-machine"
  resource_group_name = azurerm_resource_group.positive3.name
  location            = azurerm_resource_group.positive3.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.positive3.id,
  ]

  admin_ssh_key {                                     # ssh key array
    username   = "adminuser_1"
    # missing "public_key" (tecnically required)
  }

  admin_ssh_key {
    username   = "adminuser_2"
    # missing "public_key" (tecnically required)
  }
}
