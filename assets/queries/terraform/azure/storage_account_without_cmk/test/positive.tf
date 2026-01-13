resource "azurerm_storage_account" "positive1_1" {
  name                     = "storageaccountname"
  resource_group_name      = azurerm_resource_group.positive1_1.name
  location                 = azurerm_resource_group.positive1_1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  # missing "customer_managed_key" block
}

resource "azurerm_monitor_diagnostic_setting" "positive1_1" {
  name               = "positive1_1"
  target_resource_id = azurerm_subscription.positive1_1.id

  storage_account_id = azurerm_storage_account.positive1_1.id
}
