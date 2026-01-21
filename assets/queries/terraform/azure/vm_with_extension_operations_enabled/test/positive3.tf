resource "azurerm_windows_virtual_machine" "positive3_1" {
  name                = "positive3_1-machine"
  resource_group_name = azurerm_resource_group.positive3_1.name
  location            = azurerm_resource_group.positive3_1.location
  size                = "Standard_F2"
  network_interface_ids = [
    azurerm_network_interface.positive3_1.id,
  ]

  # missing "allow_extension_operations"
}

resource "azurerm_windows_virtual_machine" "positive3_2" {
  name                = "positive3_2-machine"
  resource_group_name = azurerm_resource_group.positive3_2.name
  location            = azurerm_resource_group.positive3_2.location
  size                = "Standard_F2"
  network_interface_ids = [
    azurerm_network_interface.positive3_2.id,
  ]

  allow_extension_operations = true     # set to true
}
