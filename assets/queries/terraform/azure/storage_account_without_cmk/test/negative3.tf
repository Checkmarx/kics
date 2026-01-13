resource "azurerm_storage_account" "negative3" {   # missing associated "azurerm_monitor_diagnostic_setting"
  name                     = "storageaccountname"
  resource_group_name      = azurerm_resource_group.negative3.name
  location                 = azurerm_resource_group.negative3.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
