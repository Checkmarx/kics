resource "azurerm_virtual_machine" "positive1" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.positive1.location
  resource_group_name   = azurerm_resource_group.positive1.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  # missing "storage_os_disk" (tecnically required)
}

resource "azurerm_virtual_machine" "positive2" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.positive2.location
  resource_group_name   = azurerm_resource_group.positive2.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myosdisk1"
    create_option     = "FromImage"
    vhd_uri           = "https://<storageaccount>.blob.core.windows.net/<container>/<diskname>.vhd"
    # unmanaged disk
  }
}

resource "azurerm_virtual_machine" "positive3" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.positive3.location
  resource_group_name   = azurerm_resource_group.positive3.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"


  storage_os_disk {
    name              = "myosdisk1"
    create_option     = "FromImage"
    # missing managed_disk_type
  }
}
