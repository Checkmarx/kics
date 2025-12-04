# legacy syntax

resource "azurerm_monitor_diagnostic_setting" "positive3_1" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_databricks_workspace.example_pos3.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  log {
    category = "accounts"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "positive3_2" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_databricks_workspace.example_pos3.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  log {
    category = "accounts"
    enabled  = false
  }
}

resource "azurerm_monitor_diagnostic_setting" "positive3_3" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_databricks_workspace.example_pos3.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  log {
    category = "accounts"
    enabled  = true
  }

  log {
    category = "clusters"
    enabled  = true
  }

}

resource "azurerm_monitor_diagnostic_setting" "positive3_4" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_databricks_workspace.example_pos3.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  log {                               # one or more "disabled" log blocks (array)
    category = "accounts"
    enabled  = false
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
    enabled  = false
  }

  log {
    category = "jobs"
    enabled  = true
  }
}

resource "azurerm_databricks_workspace" "example_pos3" { # missing 1/5 required log categories ("notebook" - enabled = false)
  name                = "secure-databricks-ws"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "premium"
}
