resource "azurerm_redis_cache" "negative1" {
    name                = "timeout-redis"
    location            = "West Europe"
    resource_group_name = azurerm_resource_group.example_rg.name
    subnet_id           = azurerm_subnet.example_redis_snet.id

    family              = "P"
    capacity            = 1
    sku_name            = "Premium"
    shard_count         = 1

    enable_non_ssl_port = false
    minimum_tls_version = "1.2"

    redis_configuration {
        enable_authentication   = true
        maxmemory_policy        = "volatile-lru"
    }

    patch_schedule {
        day_of_week     = "Thursday"
        start_hour_utc  = 7
    }
}