resource "azurerm_monitor_diagnostic_setting" "negative5_3" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_databricks_workspace.example_neg5.id
  eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.example.id
  eventhub_name            = "your-eventhub-name"

  enabled_log {               # "notebook" and "jobs"
    category = "notebook"
  }

  enabled_log {
    category = "jobs"
  }
}

resource "azurerm_databricks_workspace" "example_neg5" {
  name                = "secure-databricks-ws"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "premium"
}
