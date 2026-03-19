resource "azurerm_storage_account" "base" {
  name                     = "stbase"
  resource_group_name      = "rg"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account_queue_properties" "pass_standalone" {
  storage_account_id = azurerm_storage_account.base.id

  logging {
    read                  = true
    write                 = true
    delete                = true
    version               = "1.0"
    retention_policy_days = 10
  }
}