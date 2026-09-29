resource "azurerm_monitor_diagnostic_setting" "fail_partial" {
  name               = "partial-diag"
  target_resource_id = "${azurerm_storage_account.example.id}/blobServices/default"
  storage_account_id = "id"

  enabled_log {
    category = "StorageRead"
  }
  # Faltan Write y Delete. Solo debe saltar 1 vez.
}