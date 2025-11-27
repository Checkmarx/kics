resource "azurerm_linux_virtual_machine" "negative1" {
  name                = "negative1-machine"
  resource_group_name = azurerm_resource_group.negative1.name
  location            = azurerm_resource_group.negative1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.negative1.id,
  ]

  admin_ssh_key {                                 # single ssh key
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }
}

resource "azurerm_linux_virtual_machine" "negative2" {
  name                = "negative2-machine"
  resource_group_name = azurerm_resource_group.negative2.name
  location            = azurerm_resource_group.negative2.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.negative2.id,
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
