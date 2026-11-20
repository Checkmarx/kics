resource "azurerm_cosmosdb_account" "fail_cosmos" {
  name                = "cosmos-fail"
  location            = "West Europe"
  resource_group_name = "rg"
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  consistency_policy {
    consistency_level = "Session"
  }
  geo_location {
    location          = "West Europe"
    failover_priority = 0
  }
}
