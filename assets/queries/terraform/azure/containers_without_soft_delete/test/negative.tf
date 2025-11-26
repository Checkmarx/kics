resource "azurerm_storage_account" "negative1" {
  name                     = "negative1"
  resource_group_name      = "testRG"
  location                 = "northeurope"
  account_tier             = "Premium"
  account_replication_type = "LRS"
  account_kind             = "FileStorage"

  blob_properties {
    container_delete_retention_policy {
      days = 49
    }
  }
}

resource "azurerm_storage_account" "negative2" {
  name                     = "negative2"
  resource_group_name      = "testRG"
  location                 = "northeurope"
  account_tier             = "Premium"
  account_replication_type = "LRS"
  account_kind             = "FileStorage"

  blob_properties {
    container_delete_retention_policy {} # defaults to 7 days
  }
}
