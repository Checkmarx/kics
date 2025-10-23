resource "azurerm_monitor_diagnostic_setting" "positive_1" {
  name               = "incomplete-setting"
  target_resource_id = "/subscriptions/12345678-90ab-cdef-1234-567890abcdef"  # Sample GUID

  # Missing log block(s)
}

resource "azurerm_monitor_diagnostic_setting" "positive_2" {
  name                = "incomplete-setting"
  target_resource_id  = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"

  # Missing log block(s)
}

resource "azurerm_monitor_diagnostic_setting" "positive_3" {
  name                = "incomplete-setting"
  target_resource_id  = "/subscriptions/12345678-90ab-cdef-1234-567890abcdef"  # Sample GUID

  log {
    category = "Administrative"         # Log block is disabled
    enabled  = false
  }
}

resource "azurerm_monitor_diagnostic_setting" "positive_4" {
  name                = "incomplete-setting"
  target_resource_id  = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"

  log {
    category = "Administrative"         # Log blocks are disabled
    enabled  = false
  }

  log {
    category = "Alert"
    enabled  = false
  }

  log {
    category = "Policy"
    enabled  = false
  }
}
