resource "azurerm_elastic_san_volume_group" "fail_type" {
  name           = "vg-fail-type"
  elastic_san_id = "san-id"
  # Falla por no tener encryption_type CMK
}