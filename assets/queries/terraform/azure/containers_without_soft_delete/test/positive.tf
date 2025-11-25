resource "azurerm_storage_account" "positive1" {
  name                     = "positive1"
  resource_group_name      = azurerm_resource_group.positive1.name
  location                 = azurerm_resource_group.positive1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  # missing "blob_properties"
}

resource "azurerm_storage_account" "positive2" {
  name                     = "positive2"
  resource_group_name      = azurerm_resource_group.positive2.name
  location                 = azurerm_resource_group.positive2.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  blob_properties {
    # missing "container_delete_retention_policy"
  }
}

resource "azurerm_storage_account" "positive3" {
  name                     = "positive3"
  resource_group_name      = azurerm_resource_group.positive3.name
  location                 = azurerm_resource_group.positive3.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  blob_properties {
    container_delete_retention_policy {
      days = 5                            # lower than minimum value (7)
    }
  }
}
