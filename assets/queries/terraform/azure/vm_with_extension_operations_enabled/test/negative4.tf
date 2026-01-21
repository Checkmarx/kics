resource "azurerm_windows_virtual_machine_scale_set" "negative4" {
  name                 = "negative4-vmss"
  resource_group_name  = azurerm_resource_group.negative4.name
  location             = azurerm_resource_group.negative4.location
  sku                  = "Standard_F2"
  computer_name_prefix = "vm-"

  extension_operations_enabled = false
}
