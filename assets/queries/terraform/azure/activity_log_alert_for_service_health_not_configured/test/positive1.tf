resource "azurerm_monitor_activity_log_alert" "positive1_1" {
  name                = "ServiceHealthActivityLogAlert"
  resource_group_name = var.resource_group_name
  scopes              = [data.azurerm_subscription.current.id]
  description         = "Alert for Azure Service Health events"
  enabled             = true

  criteria {
    category = "Security"  # Wrong category

     service_health {
      events    = ["Incident"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.notify_team.id
  }
}

resource "azurerm_monitor_activity_log_alert" "positive1_2" {
  name                = "ServiceHealthActivityLogAlert"
  resource_group_name = var.resource_group_name
  scopes              = [data.azurerm_subscription.current.id]
  description         = "Alert for Azure Service Health events"
  enabled             = true

  criteria {
    category = "Recommendation"  # Wrong category

     service_health {
      events    = ["Incident", "Informational"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.notify_team.id
  }
}

data "azurerm_subscription" "current" {}
