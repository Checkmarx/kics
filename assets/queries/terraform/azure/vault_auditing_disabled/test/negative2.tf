provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "example" {
  name     = "resourceGroup1"
  location = "West US"
}

resource "azurerm_monitor_diagnostic_setting" "example" {
  name               = "example"
  target_resource_id = data.azurerm_databricks_workspace.example.id
  storage_account_id = data.azurerm_storage_account.example.id

  log {
    category = "AuditEvent"
    enabled  = false

    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}
