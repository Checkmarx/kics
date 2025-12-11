resource "azurerm_role_assignment" "negative12" {
  role_definition_name = "User Access Administrator"
  scope                = "/subscriptions/12345678-1234-1234-1234-123456789abc"
  principal_id         = data.azurerm_client_config.current.object_id
  principal_type       = "ServicePrincipal"
  condition_version    = "2.0"
}