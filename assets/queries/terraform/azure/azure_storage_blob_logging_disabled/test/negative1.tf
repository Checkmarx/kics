resource "azurerm_storage_account" "pass" {
  name                     = "st-pass"
  resource_group_name      = "rg"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_monitor_diagnostic_setting" "pass_diag" {
  name               = "complete-diag"
  target_resource_id = "${azurerm_storage_account.pass.id}/blobServices/default"
  storage_account_id = "target"

  enabled_log { category = "StorageRead" }
  enabled_log { category = "StorageWrite" }
  enabled_log { category = "StorageDelete" }
}