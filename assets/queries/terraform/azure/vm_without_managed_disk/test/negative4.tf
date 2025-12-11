resource "azurerm_virtual_machine_scale_set" "negative4" {
  name                = "vmss-ssd-negative4"
  location            = azurerm_resource_group.negative4.location
  resource_group_name = azurerm_resource_group.negative4.name
  upgrade_policy_mode = "Manual"

  storage_profile_os_disk {
    caching             = "ReadWrite"
    create_option       = "FromImage"
    managed_disk_type   = "StandardSSD_LRS"
  }
}
