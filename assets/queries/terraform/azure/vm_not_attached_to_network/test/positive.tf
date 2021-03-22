resource "azurerm_virtual_machine" "positive1" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  network_interface_ids = []
  vm_size               = "Standard_DS1_v2"

  os_profile_linux_config {
    disable_password_authentication = false
  }
}