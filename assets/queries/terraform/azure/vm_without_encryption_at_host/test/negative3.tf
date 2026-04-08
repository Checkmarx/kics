resource "azurerm_windows_virtual_machine" "negative3" {
  name                = "negative3-machine"
  resource_group_name = azurerm_resource_group.negative3.name
  location            = azurerm_resource_group.negative3.location
  size                = "Standard_F2"
  network_interface_ids = [
    azurerm_network_interface.negative3.id,
  ]

  encryption_at_host_enabled = true
}
