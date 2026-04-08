# legacy syntax

resource "azurerm_monitor_diagnostic_setting" "positive2_1" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_key_vault.example.id

  log {                               # single "enabled" log block (object)
    category = "Administrative"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "positive2_2" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_key_vault.example.id

  log {                               # single "disabled" log block (object)
    category = "Administrative"
    enabled  = false
  }
}

resource "azurerm_monitor_diagnostic_setting" "positive2_3" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_key_vault.example.id

  log {                              # "log" blocks do not cover all 4 categories (array)
    category = "Administrative"
    enabled  = true
  }

  log {
    category = "Security"
    enabled  = true
  }

}

resource "azurerm_monitor_diagnostic_setting" "positive2_4" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_key_vault.example.id

  log {                               # one or more "disabled" log blocks (array)
    category = "Administrative"
    enabled  = false
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
