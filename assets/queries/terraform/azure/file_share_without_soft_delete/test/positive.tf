resource "azurerm_storage_account" "positive1" {
  name                     = "positive1"
  resource_group_name      = azurerm_resource_group.positive1.name
  location                 = azurerm_resource_group.positive1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  # missing "share_properties"
}

resource "azurerm_storage_account" "positive2" {
  name                     = "positive2"
  resource_group_name      = azurerm_resource_group.positive2.name
  location                 = azurerm_resource_group.positive2.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  share_properties {
    # missing "retention_policy"
  }
}
