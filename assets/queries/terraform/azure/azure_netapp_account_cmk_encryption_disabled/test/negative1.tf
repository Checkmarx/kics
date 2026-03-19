resource "azurerm_netapp_account" "pass" {
  name                = "pass-netapp"
  resource_group_name = "rg-example"
  location            = "West Europe"

  identity {
    type         = "UserAssigned"
    identity_ids = ["/subscriptions/000/resourceGroups/rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id"]
  }
}

resource "azurerm_netapp_account_encryption" "pass_encryption" {
  netapp_account_id         = azurerm_netapp_account.pass.id
  user_assigned_identity_id = "/subscriptions/000/resourceGroups/rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id"
  encryption_key            = "https://kv.vault.azure.net/keys/key/v1"
}