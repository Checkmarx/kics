resource "azurerm_recovery_services_vault" "fail_2" {
  name                = "fail-disabled-infrastructure"
  resource_group_name = "rg"
  location            = "West Europe"
  sku                 = "Standard"

  encryption {
    key_id                            = "key-id"
    infrastructure_encryption_enabled = false
    use_system_assigned_identity      = true
  }
}