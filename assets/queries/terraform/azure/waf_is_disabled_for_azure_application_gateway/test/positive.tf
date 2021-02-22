resource "azurerm_application_gateway" "disabled_waf" {
  name                = "example-appgateway"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  waf_configuration {
    enabled = false
  }
}

resource "azurerm_application_gateway" "no_waf" {
  name                = "example-appgateway"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}