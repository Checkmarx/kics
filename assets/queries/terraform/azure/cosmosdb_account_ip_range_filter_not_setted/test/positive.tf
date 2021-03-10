resource "azurerm_cosmosdb_account" "positive1" {
  name                  = "example" 
  is_virtual_network_filter_enabled = true
 

}