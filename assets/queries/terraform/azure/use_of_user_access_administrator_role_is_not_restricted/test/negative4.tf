resource "azurerm_role_assignment" "negative4" {
  role_definition_id   = "b24988ac-6180-42a0-ab88-20f7382dd24c"
  scope                = "/providers/Microsoft.Management/managementGroups/contoso-root"
  principal_id         = data.azurerm_client_config.current.object_id
  principal_type       = "ServicePrincipal"
  condition_version    = "2.0"
}
