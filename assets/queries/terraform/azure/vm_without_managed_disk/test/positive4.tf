resource "azurerm_virtual_machine_scale_set" "positive4_1" {
  name                = "vmss-premium-positive4_1"
  location            = azurerm_resource_group.positive4_1.location
  resource_group_name = azurerm_resource_group.positive4_1.name
  upgrade_policy_mode = "Manual"

  storage_profile_os_disk {
    caching             = "ReadOnly"
    create_option       = "FromImage"
    vhd_containers = [
      "https://mystorageaccount.blob.core.windows.net/vhds/"
    ]
    # vhd_containers instead of "managed_disk_type"
  }
}

resource "azurerm_virtual_machine_scale_set" "positive4_2" {
  name                = "vmss-premium-positive4_2"
  location            = azurerm_resource_group.positive4_2.location
  resource_group_name = azurerm_resource_group.positive4_2.name
  upgrade_policy_mode = "Manual"

  storage_profile_os_disk {
    caching             = "ReadOnly"
    create_option       = "FromImage"
    os_type = "Linux"   # Required when using "image"
    image   = "https://mystorageaccount.blob.core.windows.net/system/Microsoft.Compute/Images/custom-os-image/osDisk.vhd"
    # image instead of "managed_disk_type"
  }
}
