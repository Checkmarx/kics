resource "azurerm_linux_virtual_machine_scale_set" "negative2_1" {
  name                = "negative2_1-machine"
  resource_group_name = azurerm_resource_group.negative2_1.name
  location            = azurerm_resource_group.negative2_1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.negative2_1.id,
  ]

  admin_ssh_key {                                 # single ssh key
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }
}

resource "azurerm_linux_virtual_machine_scale_set" "negative2_2" {
  name                = "negative2_2-machine"
  resource_group_name = azurerm_resource_group.negative2_2.name
  location            = azurerm_resource_group.negative2_2.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.negative2_2.id,
  ]

  admin_ssh_key {                                 # ssh key array
    username   = "adminuser_1"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  admin_ssh_key {
    username   = "adminuser_2"
    public_key = file("~/.ssh/id_rsa.pub")
  }
}
