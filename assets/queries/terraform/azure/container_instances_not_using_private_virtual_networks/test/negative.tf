resource "azurerm_container_group" "negative" {
  name                = "cg-negative"
  location            = "westeurope"
  resource_group_name = "rg-test"
  os_type = "Linux"

  ip_address_type = "Private"

  container {
    name   = "app"
    image  = "nginx"
    cpu    = 1
    memory = 1
  }
}
