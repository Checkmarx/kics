resource "azurerm_monitor_diagnostic_setting" "positive5_1" {
  name               = "databricks-diagnostic-logs"
  target_resource_id = azurerm_key_vault.example_pos5.id

  # missing valid destination

  enabled_log {
    category_group = "allLogs"
  }

  enabled_log {
    category_group = "audit"
  }
}

resource "azurerm_monitor_diagnostic_setting" "positive5_2" {
  name               = "databricks-diagnostic-logs"
  target_resource_id = azurerm_key_vault.example_pos5.id

  # missing valid destination

  log {
    category_group = "allLogs"
    enabled  = true
  }

  log {
    category_group = "audit"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "positive5_3" {
  name               = "databricks-diagnostic-logs"
  target_resource_id = azurerm_key_vault.example_pos5.id

  # missing valid destination

  log {                         # missing "enabled" - defaults to true
    category_group = "allLogs"
  }

  log {
    category_group = "audit"
  }
}

resource "azurerm_key_vault" "example_pos5" {
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
