resource "azurerm_storage_account" "fail_none" {
  name                     = "st-no-table-diag"
  resource_group_name      = "rg"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}