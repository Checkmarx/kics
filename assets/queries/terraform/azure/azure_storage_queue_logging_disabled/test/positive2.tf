resource "azurerm_storage_account" "fail_2" {
  name                     = "stfail2"
  resource_group_name      = "rg"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  queue_properties {
    logging {
      read    = true
      write   = false
      delete  = true
      version = "1.0"
    }
  }
}