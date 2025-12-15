resource "azurerm_role_assignment" "negative6" {
  role_definition_id   = "18d7d88d-d35e-4fb5-a5c3-7773c20a72d9"
  scope                = data.azurerm_subscription.primary.id
  principal_id         = data.azurerm_client_config.current.object_id
  principal_type       = "ServicePrincipal"
  condition_version    = "2.0"
}