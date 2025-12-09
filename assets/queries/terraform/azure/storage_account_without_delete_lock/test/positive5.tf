resource "azurerm_resource_group" "example_pos5" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "example_pos5" {
  name                     = "examplestorageacct"
  resource_group_name      = azurerm_resource_group.example_pos5.name
  location                 = azurerm_resource_group.example_pos5.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_management_lock" "storage_delete_lock_pos5_1" {
  name               = "storage-delete-lock"
  scope              = azurerm_storage_account.not_example_pos5.id    # incorrect referencing
  lock_level         = "CanNotDelete"
  notes              = "Prevent accidental deletion of the storage account"
}

resource "azurerm_management_lock" "storage_delete_lock_pos5_2" {
  name               = "storage-delete-lock"
  scope              = azurerm_resource_group.not_example_pos5.id      # incorrect referencing
  lock_level         = "CanNotDelete"
  notes              = "Prevent accidental deletion of the storage account"
}
