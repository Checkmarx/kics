resource "azurerm_role_assignment" "positive3" {
  role_definition_name = "User Access Administrator"
  scope                = "/providers/Microsoft.Management/managementGroups/contoso-root"
  principal_id         = data.azurerm_client_config.current.object_id
  principal_type       = "ServicePrincipal"
  condition_version    = "2.0"
}