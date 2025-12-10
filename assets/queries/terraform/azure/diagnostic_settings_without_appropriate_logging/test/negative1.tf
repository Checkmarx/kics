resource "azurerm_monitor_diagnostic_setting" "negative_1" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_key_vault.example.id

  enabled_log {                     # "enabled_log" for all 4 categories
    category = "Administrative"
  }

  enabled_log {
    category = "Alert"
  }

  enabled_log {
    category = "Policy"
  }

  enabled_log {
    category = "Security"
  }
}

resource "azurerm_monitor_diagnostic_setting" "negative_2" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_key_vault.example.id

  log {                               # legacy syntax - "log" with "enabled" set to true for all 4 categories
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

  log {
    category = "Security"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "negative_3" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_key_vault.example.id

  log {                               # legacy syntax - "log" with "enabled" set to true for all 4 categories
    category = "Administrative"       # "enabled" defaults to true
  }

  log {
    category = "Alert"
  }

  log {
    category = "Policy"
    enabled = true
  }

  log {
    category = "Security"
  }
}
