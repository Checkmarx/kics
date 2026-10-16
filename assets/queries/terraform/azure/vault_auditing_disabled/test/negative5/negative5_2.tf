resource "azurerm_monitor_diagnostic_setting" "negative5_2" {
  name               = "databricks-diagnostic-logs"
  target_resource_id = azurerm_key_vault.example_neg5.id

  storage_account_id       = azurerm_storage_account.example.id

  enabled_log {
    category_group = "audit"
  }
}
