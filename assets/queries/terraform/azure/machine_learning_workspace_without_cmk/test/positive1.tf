resource "azurerm_machine_learning_workspace" "positive1" {
  name                    = "example-mlworkspace"
  location                = azurerm_resource_group.example.location
  resource_group_name     = azurerm_resource_group.example.name
  application_insights_id = azurerm_application_insights.example.id
  key_vault_id            = azurerm_key_vault.example.id
  storage_account_id      = azurerm_storage_account.example.id
  identity {
    type = "SystemAssigned"
  }
}
