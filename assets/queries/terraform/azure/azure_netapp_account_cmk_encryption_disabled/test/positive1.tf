resource "azurerm_netapp_account" "fail" {
  name                = "fail-netapp"
  resource_group_name = "rg-example"
  location            = "West Europe"
}