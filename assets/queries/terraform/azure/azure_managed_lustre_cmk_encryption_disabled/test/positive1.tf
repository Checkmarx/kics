resource "azurerm_managed_lustre_file_system" "fail" {
  name                   = "fail-lustre"
  resource_group_name    = "rg"
  location               = "West Europe"
  sku_name               = "AMLFS-Durable-Premium-250"
  subnet_id              = "subnet-id"
  storage_capacity_in_tb = 48
}