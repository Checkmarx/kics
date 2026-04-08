resource "azurerm_storage_account" "negative1" {      # associated with "azurerm_storage_account_customer_managed_key" resource
  name                     = "storageaccountname"
  resource_group_name      = azurerm_resource_group.negative1.name
  location                 = azurerm_resource_group.negative1.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

resource "azurerm_monitor_diagnostic_setting" "negative1" {
  name               = "negative1"
  target_resource_id = azurerm_subscription.negative1.id

  storage_account_id = azurerm_storage_account.negative1.id
}

resource "azurerm_storage_account_customer_managed_key" "negative1" {
  storage_account_id = azurerm_storage_account.negative1.id
  key_vault_id       = azurerm_key_vault.negative1.id
  key_name           = azurerm_key_vault_key.negative1.name
}
