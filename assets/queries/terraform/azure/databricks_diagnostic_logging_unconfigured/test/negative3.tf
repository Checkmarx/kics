resource "azurerm_monitor_diagnostic_setting" "negative3_1" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_databricks_workspace.example_neg3.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  enabled_log {                               # "accounts"
    category = "accounts"
  }
}

resource "azurerm_monitor_diagnostic_setting" "negative3_2" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_databricks_workspace.example_neg3.id
  storage_account_id       = azurerm_storage_account.example.id

  enabled_log {                              # "clusters" and "Filesystem"
    category = "clusters"
  }

  enabled_log {
    category = "Filesystem"
  }

}

resource "azurerm_monitor_diagnostic_setting" "negative3_3" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_databricks_workspace.example_neg3.id
  eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.example.id
  eventhub_name            = "your-eventhub-name"

  enabled_log {               # "notebook" and "jobs"
    category = "notebook"
  }

  enabled_log {
    category = "jobs"
  }
}

resource "azurerm_databricks_workspace" "example_neg3" {
  name                = "secure-databricks-ws"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "premium"
}
