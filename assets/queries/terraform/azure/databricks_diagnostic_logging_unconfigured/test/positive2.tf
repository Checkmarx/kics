resource "azurerm_monitor_diagnostic_setting" "positive2_1" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_databricks_workspace.example_pos2.id

  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  # Not declaring a single "enabled_log"/"log" block
}

resource "azurerm_monitor_diagnostic_setting" "positive2_2" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_databricks_workspace.example_pos2.id

  storage_account_id       = azurerm_storage_account.example.id

  enabled_log {
    category = "accounts"         # single "enabled_log" block (object)
  }

}

resource "azurerm_monitor_diagnostic_setting" "positive2_3" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_databricks_workspace.example_pos2.id

  eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.example.id
  eventhub_name            = "your-eventhub-name"

  enabled_log {
    category = "accounts"         # "enabled_log" blocks do not cover both required categories (array)
  }

  enabled_log {
    category = "clusters"
  }
}

resource "azurerm_databricks_workspace" "example_pos2" {
  name                = "secure-databricks-ws"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "premium"
}
