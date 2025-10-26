resource "azurerm_monitor_diagnostic_setting" "positive4" {
  name               = "example"
  target_resource_id = azurerm_databricks_workspace.not_example_pos4.id  # incorrect referencing

  enabled_log {
    category = "audit"
  }

  enabled_log {
    category = "allLogs"
  }
}

resource "azurerm_databricks_workspace" "example_pos4" {
  name                = "secure-databricks-ws"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "premium"
}
