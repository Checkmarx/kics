resource "azurerm_storage_account" "positive1" {
  name                     = "examplestorageacc3"
  resource_group_name      = "example-rg"
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  customer_managed_key {
    user_assigned_identity_id = azurerm_user_assigned_identity.example.id
  }
}
