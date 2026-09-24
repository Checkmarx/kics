resource "azurerm_servicebus_namespace" "negative1" {
  name                = "example-sbnamespace"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Premium"
  customer_managed_key {
    key_vault_key_id = azurerm_key_vault_key.example.id
    identity_id      = azurerm_user_assigned_identity.example.id
  }
}
