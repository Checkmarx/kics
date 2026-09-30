resource "azurerm_redis_cache" "positive1" {
  name                = "example-cache-positive1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  capacity            = 2
  family              = "C"
  sku_name            = "Standard"
}