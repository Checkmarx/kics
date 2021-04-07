resource "azurerm_network_watcher_flow_log" "negative1" {
    network_watcher_name = azurerm_network_watcher.test.name
    resource_group_name  = azurerm_resource_group.test.name
    network_security_group_id = azurerm_network_security_group.test.id
    storage_account_id        = azurerm_storage_account.test.id
    enabled                   = true

    retention_policy {
    enabled = true
    days    = 90
    }
}

resource "azurerm_network_watcher_flow_log" "negative2" {
    network_watcher_name = azurerm_network_watcher.test.name
    resource_group_name  = azurerm_resource_group.test.name
    network_security_group_id = azurerm_network_security_group.test.id
    storage_account_id        = azurerm_storage_account.test.id
    enabled                   = true

    retention_policy {
    enabled = true
    days    = 900
    }
}