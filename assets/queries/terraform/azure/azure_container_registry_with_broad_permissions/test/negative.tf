resource "azurerm_container_registry" "sample" {
  name                = "exampleacr123"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_role_assignment" "negative1" {
  principal_id         = azurerm_kubernetes_cluster.sample.object_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.sample.id
}

resource "azurerm_role_assignment" "negative2" {
  principal_id         = azurerm_kubernetes_cluster.sample.object_id
  role_definition_id   = "7f951dda-4ed3-4680-a7ca-43fe172d538d"         # id for ArcPull
  scope                = azurerm_container_registry.sample.id
}
