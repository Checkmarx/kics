resource "azurerm_virtual_machine" "positive1" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.positive1.location
  resource_group_name   = azurerm_resource_group.positive1.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  # missing "storage_os_disk" (technically required)
}

resource "azurerm_virtual_machine" "positive1_2" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.positive1_2.location
  resource_group_name   = azurerm_resource_group.positive1_2.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "myosdisk1"
    create_option     = "FromImage"
    vhd_uri           = "https://<storageaccount>.blob.core.windows.net/<container>/<diskname>.vhd"
    # unmanaged disk
  }
}

resource "azurerm_virtual_machine" "positive1_3" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.positive1_3.location
  resource_group_name   = azurerm_resource_group.positive1_3.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"


  storage_os_disk {
    name              = "myosdisk1"
    create_option     = "FromImage"
    # missing managed_disk_type/managed_disk_id
  }
}
