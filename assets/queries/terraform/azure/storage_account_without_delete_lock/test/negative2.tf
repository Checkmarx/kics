resource "azurerm_resource_group" "example_neg2" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "example_neg2" {
  name                     = "examplestorageacct"
  resource_group_name      = azurerm_resource_group.example_neg2.name
  location                 = azurerm_resource_group.example_neg2.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_management_lock" "storage_delete_lock_neg2" {
  name               = "storage-delete-lock"
  scope              = azurerm_resource_group.example_neg2.id
  lock_level         = "CanNotDelete"
  notes              = "Prevent accidental deletion of the storage account"
}
