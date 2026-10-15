resource "azurerm_iothub" "fail" {
  name                = "example-iothub-fail"
  resource_group_name = "rg-test"
  location            = "West Europe"
  
  sku {
    name     = "S1"
    capacity = "1"
  }
}