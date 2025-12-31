resource "azurerm_virtual_machine" "negative1_1" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.negative1_1.location
  resource_group_name   = azurerm_resource_group.negative1_1.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
}

resource "azurerm_virtual_machine" "negative1_2" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.negative1_2.location
  resource_group_name   = azurerm_resource_group.negative1_2.name
  network_interface_ids = [azurerm_network_interface.negative1_2.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option   = "Attach"
    managed_disk_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Compute/disks/myManagedDisk"
  }
}
