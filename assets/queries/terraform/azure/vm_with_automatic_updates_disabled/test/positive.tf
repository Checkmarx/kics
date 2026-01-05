resource "azurerm_windows_virtual_machine" "positive1" {
  name                = "positive1-machine"
  resource_group_name = azurerm_resource_group.positive1.name
  location            = azurerm_resource_group.positive1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.positive1.id,
  ]

  enable_automatic_updates = false
}

resource "azurerm_windows_virtual_machine" "positive2" {
  name                = "positive2-machine"
  resource_group_name = azurerm_resource_group.positive2.name
  location            = azurerm_resource_group.positive2.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.positive2.id,
  ]

  automatic_updates_enabled = false
}


resource "azurerm_windows_virtual_machine_scale_set" "positive3" {
  name                 = "positive3-vmss"
  resource_group_name  = azurerm_resource_group.positive3.name
  location             = azurerm_resource_group.positive3.location
  sku                  = "Standard_F2"
  instances            = 1
  admin_username       = "adminuser"
  computer_name_prefix = "vm-"

  enable_automatic_updates = false
}
