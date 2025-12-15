resource "azurerm_storage_account" "example_pos1" {
  name                     = "examplestorageacct"
  location                 = azurerm_resource_group.example_pos1.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# no azurerm_management_lock
