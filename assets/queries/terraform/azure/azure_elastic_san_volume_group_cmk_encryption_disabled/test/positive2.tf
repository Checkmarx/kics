resource "azurerm_elastic_san_volume_group" "fail_blocks" {
  name            = "vg-fail-blocks"
  elastic_san_id  = "san-id"
  encryption_type = "EncryptionAtRestWithCustomerManagedKey"
  # Falla por faltar bloques encryption e identity
}