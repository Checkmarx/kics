resource "azurerm_windows_virtual_machine" "positive3" {
  name                = "positive3-machine"
  resource_group_name = azurerm_resource_group.positive3.name
  location            = azurerm_resource_group.positive3.location
  size                = "Standard_F2"
  admin_username      = "adminuser"

  # missing os_managed_disk_id
}
