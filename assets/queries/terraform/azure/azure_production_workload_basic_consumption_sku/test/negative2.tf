resource "azurerm_api_management" "pass_apim" {
  name                = "pass-apim"
  location            = "West Europe"
  resource_group_name = "rg"
  publisher_name      = "Company"
  publisher_email     = "email@test.com"
  sku_name            = "Standard_1"
}