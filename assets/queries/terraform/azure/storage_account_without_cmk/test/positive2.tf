resource "azurerm_storage_account" "positive2_1" {
  name                     = "storageaccountname"
  resource_group_name      = azurerm_resource_group.positive2_1.name
  location                 = azurerm_resource_group.positive2_1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_monitor_diagnostic_setting" "positive2_1" {
  name               = "positive2_1"
  target_resource_id = azurerm_subscription.positive2_1.id

  storage_account_id = azurerm_storage_account.positive2_1.id
}

# missing "azurerm_storage_account_customer_managed_key" association
