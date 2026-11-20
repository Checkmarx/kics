resource "azurerm_storage_account" "example" {
  name                     = "st-table-partial"
  resource_group_name      = "rg"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_monitor_diagnostic_setting" "fail_partial" {
  name               = "partial-table-diag"
  target_resource_id = "${azurerm_storage_account.example.id}/tableServices/default"
  storage_account_id = "target"

  # Faltan categorías de log
  enabled_log {
    category = "StorageRead"
  }
}