resource "azurerm_iothub" "pass" {
  name                = "example-iothub-pass"
  resource_group_name = "rg-test"
  location            = "West Europe"
  
  sku {
    name     = "S1"
    capacity = "1"
  }
}

resource "azurerm_iot_security_solution" "pass" {
  name                = "example-security-solution"
  resource_group_name = "rg-test"
  location            = "West Europe"
  display_name        = "Iot Security Solution"
  iothub_ids          = [azurerm_iothub.pass.id]
}