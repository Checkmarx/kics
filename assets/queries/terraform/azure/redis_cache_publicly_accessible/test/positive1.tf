resource "azurerm_redis_cache" "fail" {
  name                          = "my-redis"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  capacity                      = 1
  family                        = "C"
  sku_name                      = "Standard"
  public_network_access_enabled = true
}
