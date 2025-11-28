resource "azurerm_virtual_machine_scale_set" "positive4" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
