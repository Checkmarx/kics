resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  managed_disk_id    = azurerm_managed_disk.example.id
  virtual_machine_id = azurerm_virtual_machine.negative5.id
  lun                = "10"
  caching            = "ReadWrite"
}

resource "azurerm_virtual_machine" "negative5" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.negative5.location
  resource_group_name   = azurerm_resource_group.negative5.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
}