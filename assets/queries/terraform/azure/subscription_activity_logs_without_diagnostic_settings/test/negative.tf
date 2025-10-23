resource "azurerm_monitor_diagnostic_setting" "negative_1" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  log {
    category = "Security"
    enabled  = true
  }

  log {
    category = "Administrative"
    enabled  = true
  }

  log {
    category = "Alert"
    enabled  = true
  }

  log {
    category = "Policy"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "negative_2" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = "/subscriptions/12345678-90ab-cdef-1234-567890abcdef"  # Sample GUID
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  log {
    category = "Administrative"
    enabled  = true
  }
}
