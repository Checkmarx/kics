resource "azurerm_monitor_diagnostic_setting" "negative3_1" {
  name               = "databricks-diagnostic-logs"
  target_resource_id = azurerm_key_vault.example_neg3.id

  eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.example.id
  eventhub_name            = "your-eventhub-name"

  enabled_log {
    category_group = "allLogs"
  }
}

resource "azurerm_monitor_diagnostic_setting" "negative3_2" {
  name               = "databricks-diagnostic-logs"
  target_resource_id = azurerm_key_vault.example_neg3.id

  storage_account_id       = azurerm_storage_account.example.id

  enabled_log {
    category_group = "audit"
  }
}

resource "azurerm_key_vault" "example_neg3" {
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
