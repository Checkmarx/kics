resource "azurerm_monitor_diagnostic_setting" "positive2_1" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_key_vault.example_pos2.id

  # Not declaring a single "enabled_log"/"log" block
}

resource "azurerm_monitor_diagnostic_setting" "positive2_2" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_key_vault.example_pos2.id

  enabled_log {
    category_group = "audit"         # single "enabled_log" block (object)
  }

}

resource "azurerm_monitor_diagnostic_setting" "positive2_3" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_key_vault.example_pos2.id

  enabled_log {
    category_group = "audit"         # "enabled_log" blocks do not cover both required category_group (array)
  }

  enabled_log {
    category_group = "security"
  }
}

resource "azurerm_key_vault" "example_pos2" {     # missing "allLogs" required category_group
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
