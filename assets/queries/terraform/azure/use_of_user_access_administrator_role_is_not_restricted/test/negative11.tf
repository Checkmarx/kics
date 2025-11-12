resource "azurerm_role_assignment" "negative11" {
  role_definition_id   = "18d7d88d-d35e-4fb5-a5c3-7773c20a72d9"
  scope                = "/subscriptions/12345678-1234-1234-1234-123456789abc"
  principal_id         = data.azurerm_client_config.current.object_id
  principal_type       = "ServicePrincipal"
  condition_version    = "2.0"
}