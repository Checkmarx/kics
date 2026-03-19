resource "azurerm_storage_account_queue_properties" "fail_4" {
  storage_account_id = "some-id"
  logging {
    read    = false
    write   = true
    delete  = true
    version = "1.0"
  }
}