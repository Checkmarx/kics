# legacy syntax

resource "azurerm_monitor_diagnostic_setting" "negative4_1" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_databricks_workspace.example_neg4.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  log {                               # "accounts"
    category = "accounts"
    # missing "enabled" - defaults to true
  }
}

resource "azurerm_monitor_diagnostic_setting" "negative4_2" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_databricks_workspace.example_neg4.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  log {
    category = "accounts"
    enabled  = false
  }
}

resource "azurerm_monitor_diagnostic_setting" "negative4_3" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_databricks_workspace.example_neg4.id
  storage_account_id       = azurerm_storage_account.example.id

  log {                              # "clusters" and "Filesystem"
    category = "clusters"
    enabled  = true
  }

  log {
    category = "Filesystem"
    enabled  = true
  }

}

resource "azurerm_monitor_diagnostic_setting" "negative4_4" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_databricks_workspace.example_neg4.id
  eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.example.id
  eventhub_name            = "your-eventhub-name"

  log {                               # "notebook" and "jobs"
    category = "Filesystem"
    enabled  = false
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

resource "azurerm_databricks_workspace" "example_neg4" {
  name                = "secure-databricks-ws"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "premium"
}
