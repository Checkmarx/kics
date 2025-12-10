resource "azurerm_monitor_diagnostic_setting" "negative1" {
  name               = "databricks-diagnostic-logs"
  target_resource_id = azurerm_databricks_workspace.example_neg1.id

  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
  storage_account_id       = azurerm_storage_account.example.id
  eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.example.id
  eventhub_name            = "your-eventhub-name"

  enabled_log {
    category = "accounts"
  }

  enabled_log {
    category = "Filesystem"
  }

  enabled_log {
    category = "clusters"
  }

  enabled_log {
    category = "notebook"
  }

  enabled_log {
    category = "jobs"
  }
}

resource "azurerm_databricks_workspace" "example_neg1" {
  name                = "secure-databricks-ws"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "premium"
}
