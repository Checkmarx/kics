resource "azurerm_data_factory" "pass" {
  name                   = "my-data-factory"
  location               = azurerm_resource_group.rg.location
  resource_group_name    = azurerm_resource_group.rg.name
  public_network_enabled = false
}
