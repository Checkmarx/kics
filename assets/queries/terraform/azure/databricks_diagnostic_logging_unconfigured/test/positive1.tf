resource "azurerm_databricks_workspace" "example_pos1" {    # missing 5/5 required log categories
  name                = "secure-databricks-ws"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "premium"

  # no association with "azurerm_monitor_diagnostic_setting" resource(s)
}
