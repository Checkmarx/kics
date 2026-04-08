resource "azurerm_role_assignment" "negative9" {
  role_definition_id   = "b24988ac-6180-42a0-ab88-20f7382dd24c"
  scope                = data.azurerm_subscription.primary.id
  principal_id         = data.azurerm_client_config.current.object_id
  principal_type       = "ServicePrincipal"
  condition_version    = "2.0"
}