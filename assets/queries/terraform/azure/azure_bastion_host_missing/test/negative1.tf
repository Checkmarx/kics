resource "azurerm_virtual_network" "pass_vnet" {
  name                = "secure-network"
  resource_group_name = "rg-test"
  location            = "West Europe"
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_bastion_host" "pass_bastion" {
  name                = "bastion-host"
  location            = "West Europe"
  resource_group_name = "rg-test"

  ip_configuration {
    name                 = "config"
    subnet_id            = "dummy-id"
    public_ip_address_id = "dummy-pip-id"
  }
}