resource "azurerm_storage_account" "negative2_1" {    # sets "customer_managed_key" field
  name                     = "storageaccountname"
  resource_group_name      = azurerm_resource_group.negative2_1.name
  location                 = azurerm_resource_group.negative2_1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  customer_managed_key {
    key_vault_key_id        = azurerm_key_vault_key.example.id
    user_assigned_identity_id = azurerm_user_assigned_identity.example.id
  }
}

resource "azurerm_monitor_diagnostic_setting" "negative2_1" {
  name               = "negative2_1"
  target_resource_id = azurerm_subscription.negative2_1.id

  storage_account_id = azurerm_storage_account.negative2_1.id
}
