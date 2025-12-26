resource "azurerm_container_group" "positive1" {
  name                = "cg-positive1"
  location            = "westeurope"
  resource_group_name = "rg-test"
  os_type = "Linux"

  container {
    name   = "app"
    image  = "nginx"
    cpu    = 1
    memory = 1
  }
}
