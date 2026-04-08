resource "azurerm_linux_virtual_machine" "negative1_1" {
  name                = "negative1_1-machine"
  resource_group_name = azurerm_resource_group.negative1_1.name
  location            = azurerm_resource_group.negative1_1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.negative1_1.id,
  ]

  admin_ssh_key {                                 # single ssh key
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }
}

resource "azurerm_linux_virtual_machine" "negative1_2" {
  name                = "negative1_2-machine"
  resource_group_name = azurerm_resource_group.negative1_2.name
  location            = azurerm_resource_group.negative1_2.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.negative1_2.id,
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
