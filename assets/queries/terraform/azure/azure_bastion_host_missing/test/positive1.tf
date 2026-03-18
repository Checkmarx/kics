resource "azurerm_virtual_network" "fail_vnet" {
  name                = "vulnerable-network"
  resource_group_name = "rg-test"
  location            = "West Europe"
  address_space       = ["10.0.0.0/16"]
}