resource "azurerm_service_plan" "pass_sp" {
  name                = "pass-sp"
  resource_group_name = "rg"
  location            = "West Europe"
  os_type             = "Linux"
  sku_name            = "S1"
}