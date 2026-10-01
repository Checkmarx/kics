resource "azurerm_monitor_diagnostic_setting" "fail_no_logs" {
  name               = "no-logs-diag"
  target_resource_id = "${azurerm_storage_account.example.id}/tableServices/default"
  storage_account_id = "id"
  # No hay bloques enabled_log
}