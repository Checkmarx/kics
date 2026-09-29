resource "azurerm_service_plan" "fail_sp" {
  name                = "fail-sp"
  resource_group_name = "rg"
  location            = "West Europe"
  os_type             = "Linux"
  sku_name            = "B1"
}