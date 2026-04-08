resource "azurerm_storage_account" "positive1" {
  name                     = "positive1"
  resource_group_name      = azurerm_resource_group.positive1.name
  location                 = azurerm_resource_group.positive1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  cross_tenant_replication_enabled = true
}
