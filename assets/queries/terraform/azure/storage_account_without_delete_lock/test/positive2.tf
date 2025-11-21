resource "azurerm_storage_account" "example_pos2" {
  name                     = "examplestorageacct"
  location                 = azurerm_resource_group.example_pos2.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_management_lock" "storage_delete_lock_pos2" {
  name               = "storage-delete-lock"
  scope              = azurerm_storage_account.example_pos2.id
  lock_level         = "ReadOnly"                                       # incorrect lock level
  notes              = "Prevent accidental deletion of the storage account"
}
