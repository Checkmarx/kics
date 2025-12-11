resource "azurerm_role_assignment" "negative10" {
  role_definition_name = "Contributor"
  scope                = data.azurerm_subscription.primary.id
  principal_id         = data.azurerm_client_config.current.object_id
  principal_type       = "ServicePrincipal"
  condition_version    = "2.0"
}