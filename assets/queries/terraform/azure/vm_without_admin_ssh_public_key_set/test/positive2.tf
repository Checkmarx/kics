resource "azurerm_linux_virtual_machine_scale_set" "positive2_1" {
  name                = "positive2_1-machine"
  resource_group_name = azurerm_resource_group.positive2_1.name
  location            = azurerm_resource_group.positive2_1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.positive2_1.id,
  ]

  # missing "admin_ssh_key"
}

resource "azurerm_linux_virtual_machine_scale_set" "positive2_2" {
  name                = "positive2_2-machine"
  resource_group_name = azurerm_resource_group.positive2_2.name
  location            = azurerm_resource_group.positive2_2.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.positive2_2.id,
  ]

  admin_ssh_key {                                   # single ssh key
    username   = "adminuser"
    # missing "public_key" (tecnically required)
  }
}

resource "azurerm_linux_virtual_machine_scale_set" "positive2_3" {
  name                = "positive2_3-machine"
  resource_group_name = azurerm_resource_group.positive2_3.name
  location            = azurerm_resource_group.positive2_3.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.positive2_3.id,
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
