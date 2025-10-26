resource "azurerm_monitor_diagnostic_setting" "negative_1" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_key_vault.example_neg.id

  enabled_log {                     # "enabled_log" for all both category groups
    category_group = "audit"
  }

  enabled_log {
    category_group = "allLogs"
  }
}

resource "azurerm_monitor_diagnostic_setting" "negative_2" {
  name                       = "diagnostic-settings-name"
  target_resource_id = data.azurerm_key_vault.example_neg.id

  log {                               # legacy syntax - "log" with "enabled" set to true for both category groups
    category_group = "audit"
    enabled  = true
  }

  log {
    category_group = "allLogs"
    enabled  = true
  }
}

resource "azurerm_key_vault" "example_neg" {
  name                        = "testvault"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled         = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"
}
