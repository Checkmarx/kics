resource "azurerm_key_vault" "example" {
  name                        = "example-vault"
  location                    = "West US"
  resource_group_name         = "example-resources"
}

data "azurerm_key_vault" "example" {
  name                = "example-vault"
  resource_group_name = "example-resources"
}

resource "azurerm_monitor_diagnostic_setting" "example" {
  name               = "example"
  target_resource_id = data.azurerm_key_vault.example.id
  storage_account_id = data.azurerm_storage_account.example.id

  log {
    category = "AuditEvent"
    enabled  = true
  }
}
