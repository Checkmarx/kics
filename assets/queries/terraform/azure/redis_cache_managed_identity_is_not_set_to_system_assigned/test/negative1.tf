resource "azurerm_redis_cache" "negative1" {
  name                = "example-cache"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  capacity            = 2
  family              = "C"
  sku_name            = "Standard"

  identity {
    type = "SystemAssigned"
  }
}
