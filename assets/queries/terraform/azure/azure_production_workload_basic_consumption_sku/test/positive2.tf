resource "azurerm_api_management" "fail_apim" {
  name                = "fail-apim"
  location            = "West Europe"
  resource_group_name = "rg"
  publisher_name      = "Company"
  publisher_email     = "email@test.com"
  sku_name            = "Consumption_0"
}