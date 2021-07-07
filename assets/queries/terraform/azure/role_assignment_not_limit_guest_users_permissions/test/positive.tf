resource "azurerm_role_definition" "example" {
  name        = "my-custom-role"
  scope       = data.azurerm_subscription.primary.id
  description = "This is a custom role created via Terraform"

  permissions {
    actions     = ["*"]
    not_actions = []
  }

  assignable_scopes = [
    data.azurerm_subscription.primary.id, 
  ]
}

resource "azurerm_role_assignment" "example" {
  name               = "00000000-0000-0000-0000-000000000000"
  scope              = data.azurerm_subscription.primary.id
  role_definition_name = "Guest"
  role_definition_id = azurerm_role_definition.example.role_definition_resource_id
  principal_id       = data.azurerm_client_config.example.object_id
}
