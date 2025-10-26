# legacy syntax

resource "azurerm_monitor_diagnostic_setting" "positive3_1" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_databricks_workspace.example_pos3.id

  log {                               # single "enabled" log block (object)
    category = "accounts"
    enabled  = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "positive3_2" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_databricks_workspace.example_pos3.id

  log {                               # single "disabled" log block (object)
    category = "accounts"
    enabled  = false
  }
}

resource "azurerm_monitor_diagnostic_setting" "positive3_3" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_databricks_workspace.example_pos3.id

  log {                              # "log" blocks do not cover both category groups (array)
    category = "accounts"
    enabled  = true
  }

  log {
    category = "clusters"
    enabled  = true
  }

}

resource "azurerm_monitor_diagnostic_setting" "positive3_4" {
  name                       = "diagnostic-settings-name"
  target_resource_id         = azurerm_databricks_workspace.example_pos3.id

  log {                               # one or more "disabled" log blocks (array)
    category = "accounts"
    enabled  = false
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
    enabled  = false
  }

  log {
    category = "jobs"
    enabled  = true
  }
}

resource "azurerm_databricks_workspace" "example_pos3" {
  name                = "secure-databricks-ws"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "premium"
}
