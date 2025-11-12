resource "azurerm_role_assignment" "negative5" {
  role_definition_name = "User Access Administrator"
  scope                = data.azurerm_subscription.primary.id
  principal_id         = data.azurerm_client_config.current.object_id
  principal_type       = "ServicePrincipal"
  condition_version    = "2.0"
}