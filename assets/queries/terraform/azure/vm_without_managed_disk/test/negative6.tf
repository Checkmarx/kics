resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  managed_disk_id    = azurerm_managed_disk.example.id
  virtual_machine_id = azurerm_virtual_machine.negative6.id
  lun                = "10"
  caching            = "ReadWrite"
}

resource "azurerm_virtual_machine" "negative6" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.negative6.location
  resource_group_name   = azurerm_resource_group.negative6.name
  network_interface_ids = [azurerm_network_interface.negative6.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option   = "Attach"
    managed_disk_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.Compute/disks/myManagedDisk"
  }
}