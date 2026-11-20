resource "azurerm_recovery_services_vault" "pass" {
  name                = "vault-pass"
  resource_group_name = "rg"
  location            = "West Europe"
  sku                 = "Standard"

  identity {
    type = "SystemAssigned"
  }

  encryption {
    key_id                            = "https://kv.vault.azure.net/keys/key/v1"
    infrastructure_encryption_enabled = true
    use_system_assigned_identity      = true
  }
}