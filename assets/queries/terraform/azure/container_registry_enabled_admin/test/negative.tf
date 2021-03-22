resource "azurerm_resource_group" "negative1" {
  name     = "resourceGroup1"
  location = "West US"
}

resource "azurerm_container_registry" "negative2" {
  name                     = "containerRegistry1"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  sku                      = "Premium"
  admin_enabled            = false
  georeplication_locations = ["East US", "West Europe"]
}