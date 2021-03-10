#this code is a correct code for which the query should not find any result
resource "azure_virtual_network" "negative1" {
  name          = "test-network"
  address_space = ["10.1.2.0/24"]
  location      = "West US"

  subnet {
    name           = "subnet1"
    address_prefix = "10.1.2.0/25"
    security_group = "a"
  }
}