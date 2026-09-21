resource "azurerm_redis_cache" "negative" {
  name                 = "example-cache"
  location             = azurerm_resource_group.example.location
  resource_group_name  = azurerm_resource_group.example.name
  capacity             = 2
  family               = "C"
  sku_name             = "Standard"
  non_ssl_port_enabled = false
  minimum_tls_version  = "1.2"
}