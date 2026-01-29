resource "azurerm_container_registry" "sample" {
  name                = "exampleacr123"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_role_assignment" "positive1" {
  principal_id         = azurerm_kubernetes_cluster.sample.object_id
  role_definition_name = "AcrPush"
  scope                = azurerm_container_registry.sample.id
}

resource "azurerm_role_assignment" "positive2" {
  principal_id         = azurerm_kubernetes_cluster.sample.object_id
  role_definition_id   = "8311e382-0749-4cb8-b61a-304f252e45ec"         # id for AcrPush
  scope                = azurerm_container_registry.sample.id
}
