resource "azurerm_storage_container_immutability_policy" "fail_explicit" {
  storage_container_resource_manager_id = "some-resource-id"
  immutability_period_in_days           = 90
  locked                                = false
}