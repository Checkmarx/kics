resource "azurerm_cosmosdb_account" "db" {
  name                  = "example" 
  is_virtual_network_filter_enabled = true
 

}