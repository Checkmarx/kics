resource "azurerm_linux_virtual_machine" "negative2" {
  name                = "negative2-machine"
  resource_group_name = azurerm_resource_group.negative2.name
  location            = azurerm_resource_group.negative2.location
  size                = "Standard_F2"
  admin_username      = "adminuser"

  os_managed_disk_id  = azurerm_managed_disk.negative2.id
}
