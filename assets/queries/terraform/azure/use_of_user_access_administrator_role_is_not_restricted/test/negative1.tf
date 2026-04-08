resource "azurerm_role_assignment" "negative1" {
  role_definition_name = "Contributor"
  scope                = data.azurerm_management_group.primary.id
  principal_id         = data.azurerm_client_config.current.object_id
  principal_type       = "ServicePrincipal"
  condition_version    = "2.0"
}