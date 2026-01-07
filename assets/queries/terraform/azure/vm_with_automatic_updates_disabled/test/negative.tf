resource "azurerm_windows_virtual_machine" "negative1" {
  name                = "negative1-machine"
  resource_group_name = azurerm_resource_group.negative1.name
  location            = azurerm_resource_group.negative1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.negative1.id,
  ]

  enable_automatic_updates = true
}

resource "azurerm_windows_virtual_machine" "negative2" {
  name                = "negative2-machine"
  resource_group_name = azurerm_resource_group.negative2.name
  location            = azurerm_resource_group.negative2.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.negative2.id,
  ]

  automatic_updates_enabled = true  # newer field
}

resource "azurerm_windows_virtual_machine_scale_set" "negative3" {
  name                 = "negative3-vmss"
  resource_group_name  = azurerm_resource_group.negative3.name
  location             = azurerm_resource_group.negative3.location
  sku                  = "Standard_F2"
  instances            = 1
  admin_username       = "adminuser"
  computer_name_prefix = "vm-"

  enable_automatic_updates = true
}

resource "azurerm_windows_virtual_machine" "negative4" {
  name                = "negative4-machine"
  resource_group_name = azurerm_resource_group.negative4.name
  location            = azurerm_resource_group.negative4.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.negative4.id,
  ]

  # missing "enable_automatic_updates" and "automatic_updates_enabled" - defaults to true
}

resource "azurerm_windows_virtual_machine_scale_set" "negative5" {
  name                 = "negative5-vmss"
  resource_group_name  = azurerm_resource_group.negative5.name
  location             = azurerm_resource_group.negative5.location
  sku                  = "Standard_F2"
  instances            = 1
  admin_username       = "adminuser"
  computer_name_prefix = "vm-"

  # missing "enable_automatic_updates" - defaults to true
}
