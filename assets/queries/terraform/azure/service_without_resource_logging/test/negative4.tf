resource "azurerm_storage_account" "negative4" {  #storage account without gen2_filesystem
  name                     = "storageaccountname"
  resource_group_name      = azurerm_resource_group.negative4.name
  location                 = azurerm_resource_group.negative4.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
