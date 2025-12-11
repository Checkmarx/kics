resource "azurerm_monitor_diagnostic_setting" "negative4_1_1" {
  name               = "databricks-diagnostic-logs"
  target_resource_id = azurerm_key_vault.example_neg4_1.id

  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  log {
    category_group = "allLogs"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "negative4_1_2" {
  name               = "databricks-diagnostic-logs"
  target_resource_id = azurerm_key_vault.example_neg4_1.id

  storage_account_id       = azurerm_storage_account.example.id

  log {
    category_group = "audit"
    enabled  = true
  }
}

resource "azurerm_key_vault" "example_neg4_1" {
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

resource "azurerm_monitor_diagnostic_setting" "negative4_2_1" {
  name               = "databricks-diagnostic-logs"
  target_resource_id = azurerm_key_vault.example_neg4_2.id

  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  log {                         # missing "enabled" - defaults to true
    category_group = "allLogs"
  }
}

resource "azurerm_monitor_diagnostic_setting" "negative4_2_2" {
  name               = "databricks-diagnostic-logs"
  target_resource_id = azurerm_key_vault.example_neg4_2.id

  eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.example.id
  eventhub_name            = "your-eventhub-name"

  log {
    category_group = "audit"
  }
}

resource "azurerm_key_vault" "example_neg4_2" {
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
