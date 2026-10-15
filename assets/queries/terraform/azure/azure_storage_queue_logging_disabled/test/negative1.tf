resource "azurerm_storage_account" "pass_inline" {
  name                     = "stpassinline"
  resource_group_name      = "rg"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  queue_properties {
    logging {
      read    = true
      write   = true
      delete  = true
      version = "1.0"
      retention_policy_days = 7
    }
  }
}