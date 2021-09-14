resource "azurerm_search_service" "positive1" {
  name                = "example-search-service"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "standard"
  public_network_access_enabled = true
}
