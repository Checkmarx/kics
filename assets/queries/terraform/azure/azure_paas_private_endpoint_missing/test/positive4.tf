resource "azurerm_redis_cache" "fail_redis" {
  name                = "redis-fail"
  location            = "West Europe"
  resource_group_name = "rg"
  capacity            = 1
  family              = "C"
  sku_name            = "Standard"
}
