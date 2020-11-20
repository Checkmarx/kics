resource "azurerm_cosmosdb_account" "db" {
  name                  = "example" 

  ip_range_filter       = "104.42.195.92"
  is_virtual_network_filter_enabled = true
 

}