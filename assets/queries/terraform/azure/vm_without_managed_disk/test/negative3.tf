resource "azurerm_windows_virtual_machine" "negative3" {
  name                = "negative3-machine"
  resource_group_name = azurerm_resource_group.negative3.name
  location            = azurerm_resource_group.negative3.location
  size                = "Standard_F2"
  admin_username      = "adminuser"

  os_managed_disk_id  = azurerm_managed_disk.negative3.id
}
