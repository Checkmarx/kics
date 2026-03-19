resource "azurerm_storage_account" "fail_1" {
  name                     = "stfail1"
  resource_group_name      = "rg"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  queue_properties {
    # Falta bloque logging
  }
}