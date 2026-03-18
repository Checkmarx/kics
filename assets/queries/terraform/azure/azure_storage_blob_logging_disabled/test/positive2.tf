resource "azurerm_monitor_diagnostic_setting" "fail_no_logs" {
  name               = "empty-diag"
  target_resource_id = "${azurerm_storage_account.example.id}/blobServices/default"
  storage_account_id = "id"
  # enabled_log bloque ausente
}