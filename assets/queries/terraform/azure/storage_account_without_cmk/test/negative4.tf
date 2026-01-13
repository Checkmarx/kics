resource "azurerm_storage_account" "negative4" {      # associated with "azurerm_storage_account_customer_managed_key" resource
  name                     = "storageaccountname"
  resource_group_name      = azurerm_resource_group.negative4.name
  location                 = azurerm_resource_group.negative4.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  customer_managed_key {
    key_vault_key_id        = azurerm_key_vault_key.example.id
    user_assigned_identity_id = azurerm_user_assigned_identity.example.id
  }
}

resource "azurerm_monitor_diagnostic_setting" "negative4" {
  name               = "negative4"
  target_resource_id = azurerm_subscription.negative4.id

  storage_account_id = azurerm_storage_account.negative4.id
}

resource "azurerm_storage_account_customer_managed_key" "negative4" {
  storage_account_id = azurerm_storage_account.negative4.id
  key_vault_id       = azurerm_key_vault.negative4.id
  key_name           = azurerm_key_vault_key.negative4.name
}