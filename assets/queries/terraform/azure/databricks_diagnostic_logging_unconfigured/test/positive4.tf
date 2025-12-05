resource "azurerm_monitor_diagnostic_setting" "positive4" {
  name               = "example"
  target_resource_id = azurerm_databricks_workspace.not_example_pos4.id  # incorrect referencing
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

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

resource "azurerm_databricks_workspace" "example_pos4" {
  name                = "secure-databricks-ws"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "premium"
}
