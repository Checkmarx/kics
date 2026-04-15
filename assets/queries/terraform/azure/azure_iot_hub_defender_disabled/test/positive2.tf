resource "azurerm_iothub" "fail_disabled" {
  name                = "example-iothub-fail-disabled"
  resource_group_name = "rg-test"
  location            = "West Europe"

  sku {
    name     = "S1"
    capacity = "1"
  }
}

resource "azurerm_iot_security_solution" "fail_disabled" {
  name                = "example-security-solution-disabled"
  resource_group_name = "rg-test"
  location            = "West Europe"
  display_name        = "Iot Security Solution"
  iothub_ids          = [azurerm_iothub.fail_disabled.id]
  enabled             = false
}
