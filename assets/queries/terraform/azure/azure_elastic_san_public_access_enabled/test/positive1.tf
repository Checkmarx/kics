resource "azurerm_elastic_san_volume_group" "fail" {
  name           = "insecure-vg"
  elastic_san_id = "san-id"
  # Falla por no tener network_rule
}