resource "azurerm_monitor_diagnostic_setting" "negative5_1" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_databricks_workspace.example_neg5.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  enabled_log {                               # "accounts"
    category = "accounts"
  }
}

resource "azurerm_monitor_diagnostic_setting" "negative5_2" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_databricks_workspace.example_neg5.id
  storage_account_id       = azurerm_storage_account.example.id

  enabled_log {                              # "clusters" and "Filesystem"
    category = "clusters"
  }

  enabled_log {
    category = "Filesystem"
  }

}
