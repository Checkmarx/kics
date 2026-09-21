resource "azurerm_resource_group" "example_pos4" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "example_pos4" {
  name                     = "examplestorageacct"
  # no resource_group_name to make association
  location                 = azurerm_resource_group.example_pos4.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_management_lock" "storage_delete_lock_pos4" {
  name               = "storage-delete-lock"
  scope              = azurerm_resource_group.example_pos4.id
  lock_level         = "CanNotDelete"
  notes              = "Prevent accidental deletion of the storage account"
}
