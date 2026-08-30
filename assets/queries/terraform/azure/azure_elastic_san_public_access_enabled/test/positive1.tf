resource "azurerm_elastic_san_volume_group" "fail" {
  name           = "insecure-vg"
  elastic_san_id = "san-id"
  # FAIL: Missing network_rule block
}
