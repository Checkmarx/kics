resource "azurerm_storage_account" "positive2" {
  name                     = "examplestorageacc4"
  resource_group_name      = "example-rg"
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
