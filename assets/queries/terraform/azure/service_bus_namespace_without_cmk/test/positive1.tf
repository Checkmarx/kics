resource "azurerm_servicebus_namespace" "positive1" {
  name                = "example-sbnamespace"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Premium"
}
