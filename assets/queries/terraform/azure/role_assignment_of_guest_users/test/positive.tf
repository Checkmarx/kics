resource "azurerm_role_assignment" "positive1" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Guest"
  principal_id         = data.azurerm_client_config.example.object_id
}