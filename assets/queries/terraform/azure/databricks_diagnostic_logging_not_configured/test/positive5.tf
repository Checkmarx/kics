resource "azurerm_monitor_diagnostic_setting" "positive5_1" {
  name               = "databricks-diagnostic-logs"
  target_resource_id = azurerm_databricks_workspace.example_pos5.id

  # missing valid destination

  enabled_log {
    category = "accounts"
  }

  enabled_log {
    category = "Filesystem"
  }

  enabled_log {
    category = "clusters"
  }

  enabled_log {
    category = "notebook"
  }

  enabled_log {
    category = "jobs"
  }
}

resource "azurerm_monitor_diagnostic_setting" "positive5_2" {
  name               = "databricks-diagnostic-logs"
  target_resource_id = azurerm_databricks_workspace.example_pos5.id

  # missing valid destination

  log {
    category = "accounts"
    enabled  = true
  }

  log {
    category = "Filesystem"
    enabled  = true
  }

  log {
    category = "clusters"
    enabled  = true
  }

  log {
    category = "notebook"
    enabled  = true
  }

  log {
    category = "jobs"
    enabled  = true
  }
}

resource "azurerm_databricks_workspace" "example_pos5" {
  name                = "secure-databricks-ws"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "premium"
}
