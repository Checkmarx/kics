resource "azurerm_monitor_diagnostic_setting" "positive4" {
  name               = "example"
  target_resource_id = data.azurerm_databricks_workspace.not_example_pos4.id  # incorrect referencing

  enabled_log {
    category_group = "audit"
  }

  enabled_log {
    category_group = "allLogs"
  }
}

resource "azurerm_key_vault" "example_pos4" {
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
