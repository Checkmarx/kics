resource "azurerm_elastic_san_volume_group" "pass" {
  name           = "secure-vg"
  elastic_san_id = "san-id"

  network_rule {
    subnet_id = "/subscriptions/0000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/s1"
  }
}