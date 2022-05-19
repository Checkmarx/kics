resource "azurerm_storage_account" "positive2" {
  name                     = "storageaccountname"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  min_tls_version = "TLS1_1"

  tags = {
    environment = "staging"
  }
}
