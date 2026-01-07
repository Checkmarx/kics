resource "azurerm_linux_virtual_machine_scale_set" "negative3_1" {
  name                = "negative3_1-vmss"
  resource_group_name = azurerm_resource_group.negative3_1.name
  location            = azurerm_resource_group.negative3_1.location
  sku                 = "Standard_F2"
  instances           = 1
  admin_username      = "adminuser"

  # missing "disable_password_authentication" - defaults to true
}

resource "azurerm_linux_virtual_machine_scale_set" "negative3_2" {
  name                = "negative3_2-vmss"
  resource_group_name = azurerm_resource_group.negative3_2.name
  location            = azurerm_resource_group.negative3_2.location
  sku                 = "Standard_F2"
  instances           = 1
  admin_username      = "adminuser"

  disable_password_authentication = true
}
