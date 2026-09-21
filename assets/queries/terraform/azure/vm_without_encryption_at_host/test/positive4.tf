resource "azurerm_windows_virtual_machine_scale_set" "positive4_1" {
  name                 = "positive4_1-vmss"
  resource_group_name  = azurerm_resource_group.positive4_1.name
  location             = azurerm_resource_group.positive4_1.location
  sku                  = "Standard_F2"
  computer_name_prefix = "vm-"

   # missing "encryption_at_host_enabled"
}

resource "azurerm_windows_virtual_machine_scale_set" "positive4_2" {
  name                = "positive4_2-machine"
  resource_group_name = azurerm_resource_group.positive4_2.name
  location            = azurerm_resource_group.positive4_2.location
  size                = "Standard_F2"
  network_interface_ids = [
    azurerm_network_interface.positive4_2.id,
  ]

  encryption_at_host_enabled = false     # set to false
}
