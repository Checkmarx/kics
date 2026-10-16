# legacy syntax

resource "azurerm_monitor_diagnostic_setting" "positive3_1" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_key_vault.example_pos3.id

  log {                               # single "enabled" log block (object)
    category_group = "allLogs"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "positive3_2" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_key_vault.example_pos3.id

  log {                               # single "disabled" log block (object)
    category_group = "audit"
    enabled  = false
  }
}

resource "azurerm_monitor_diagnostic_setting" "positive3_3" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_key_vault.example_pos3.id

  log {                              # "log" blocks do not cover both category groups (array)
    category_group = "allLogs"
    enabled  = true
  }

  log {
    category_group = "security"
    enabled  = true
  }

}

resource "azurerm_monitor_diagnostic_setting" "positive3_4" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_key_vault.example_pos3.id

  log {                               # one or more "disabled" log blocks (array)
    category_group = "audit"
    enabled  = true
  }

  log {
    category_group = "security"
    enabled  = true
  }

  log {
    category_group = "allLogs"
    enabled  = true
  }
}

resource "azurerm_key_vault" "example_pos3" {   # missing "audit" required category_group
  name                        = "testvault"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled         = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"
}
