resource "azurerm_storage_account" "example_neg1" {
  name                     = "examplestorageacct"
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_management_lock" "storage_delete_lock_neg1" {
  name               = "storage-delete-lock"
  scope              = azurerm_storage_account.example_neg1.id
  lock_level         = "CanNotDelete"
  notes              = "Prevent accidental deletion of the storage account"
}
