resource "azurerm_databricks_workspace" "example_neg2" {
  name                = "secure-databricks-ws"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "premium"
}

resource "azurerm_monitor_diagnostic_setting" "negative2_1" {
  name               = "databricks-diagnostic-logs"
  target_resource_id = azurerm_databricks_workspace.example_neg2.id

  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
  storage_account_id       = azurerm_storage_account.example.id
  eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.example.id
  eventhub_name            = "your-eventhub-name"

  log {
    category = "accounts"
    enabled  = true
  }

  log {
    category = "Filesystem"
    enabled  = true
  }

  log {
    category = "clusters"
    enabled  = true
  }

  log {
    category = "notebook"
    enabled  = true
  }

  log {
    category = "jobs"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "negative2_2" {
  name               = "databricks-diagnostic-logs"
  target_resource_id = azurerm_databricks_workspace.example_neg2.id

  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
  storage_account_id       = azurerm_storage_account.example.id
  eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.example.id
  eventhub_name            = "your-eventhub-name"

  log {                         # missing "enabled" - defaults to true
    category = "accounts"
  }

  log {
    category = "Filesystem"
  }

  log {
    category = "clusters"
  }

  log {
    category = "notebook"
  }

  log {
    category = "jobs"
  }
}
