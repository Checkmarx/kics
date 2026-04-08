resource "azurerm_container_group" "positive3" {
  name                = "cg-positive3"
  location            = "westeurope"
  resource_group_name = "rg-test"
  os_type = "Linux"

  ip_address_type = "None"

  container {
    name   = "app"
    image  = "nginx"
    cpu    = 1
    memory = 1
  }
}
