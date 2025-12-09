resource "azurerm_resource_group" "example_pos3" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "example_pos3" {
  name                     = "examplestorageacct"
  resource_group_name      = azurerm_resource_group.example_pos3.name
  location                 = azurerm_resource_group.example_pos3.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_management_lock" "storage_delete_lock_pos3" {
  name               = "storage-delete-lock"
  scope              = azurerm_resource_group.example_pos3.id
  lock_level         = "ReadOnly"                                       # incorrect lock level
  notes              = "Prevent accidental deletion of the storage account"
}
