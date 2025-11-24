resource "azurerm_storage_account" "positive1_1" {   # missing associated "azurerm_monitor_diagnostic_setting"
  name                     = "storageaccountname"
  resource_group_name      = azurerm_resource_group.positive1_1.name
  location                 = azurerm_resource_group.positive1_1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  customer_managed_key {
    key_vault_key_id        = azurerm_key_vault_key.example.id
    user_assigned_identity_id = azurerm_user_assigned_identity.example.id
  }
}

resource "azurerm_storage_account" "positive1_2" {
  name                     = "storageaccountname"
  resource_group_name      = azurerm_resource_group.positive1_2.name
  location                 = azurerm_resource_group.positive1_2.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  # missing "customer_managed_key" block
}

resource "azurerm_monitor_diagnostic_setting" "positive1_2" {
  name               = "positive1_2"
  target_resource_id = azurerm_subscription.positive1_2.id

  storage_account_id = azurerm_storage_account.positive1_2.id
}
