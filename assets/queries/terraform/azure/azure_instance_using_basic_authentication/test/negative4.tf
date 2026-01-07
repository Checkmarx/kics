resource "azurerm_virtual_machine_scale_set" "negative4_1" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name

  os_profile_linux_config {
    disable_password_authentication = true
  }
}

resource "azurerm_virtual_machine_scale_set" "negative4_2" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name

  # missing "os_profile_linux_config" - means it is not a linux vm
}
