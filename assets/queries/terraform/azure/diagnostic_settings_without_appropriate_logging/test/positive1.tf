resource "azurerm_monitor_diagnostic_setting" "positive1_1" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_key_vault.example.id

  # Not declaring a single "enabled_log"/"log" block
}

resource "azurerm_monitor_diagnostic_setting" "positive1_2" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_key_vault.example.id

  enabled_log {
    category = "Administrative"         # single "enabled_log" block (object)
  }

}

resource "azurerm_monitor_diagnostic_setting" "positive1_3" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_key_vault.example.id

  enabled_log {
    category = "Administrative"         # "enabled_log" blocks do not cover all 4 categories (array)
  }

  enabled_log {
    category = "Alert"
  }
}
