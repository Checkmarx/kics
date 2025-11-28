resource "azurerm_container_group" "positive2" {
  name                = "cg-positive2"
  location            = "westeurope"
  resource_group_name = "rg-test"
  os_type = "Linux"

  ip_address_type = "Public"

  container {
    name   = "app"
    image  = "nginx"
    cpu    = 1
    memory = 1
  }
}
