resource "azurerm_role_definition" "example2" {
  role_definition_id = "00000000-0000-0000-0000-000000000000"
  name               = "my-custom-role-definition"
  scope              = data.azurerm_subscription.primary.id

  permissions {
    actions     = ["Microsoft.Authorization/roleDefinitions/write"]
    not_actions = []
  }
}
