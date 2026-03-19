resource "azurerm_storage_account" "pass" {
  name                     = "st-pass-cmk"
  resource_group_name      = "rg"
  location                 = "West Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  identity {
    type = "SystemAssigned"
  }

  customer_managed_key {
    key_vault_key_id = "https://kv.vault.azure.net/keys/key/v1"
    user_assigned_identity_id = "some-id"
  }
}