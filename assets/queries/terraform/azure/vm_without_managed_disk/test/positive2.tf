resource "azurerm_linux_virtual_machine" "positive2" {
  name                = "positive2-machine"
  resource_group_name = azurerm_resource_group.positive2.name
  location            = azurerm_resource_group.positive2.location
  size                = "Standard_F2"
  admin_username      = "adminuser"

  # missing os_managed_disk_id
}
