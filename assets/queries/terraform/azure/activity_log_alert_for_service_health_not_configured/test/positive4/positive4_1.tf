# Query prioritizes flagging the log alert(s) with correct "category" but missing "Incident" on the events array over ones with wrong "category"
resource "azurerm_monitor_activity_log_alert" "positive4_1" {
  name                = "ServiceHealthActivityLogAlert"
  resource_group_name = var.resource_group_name
  scopes              = [data.azurerm_subscription.current.id]
  description         = "Alert for Azure Service Health events"
  enabled             = true

  criteria {
    category = "ServiceHealth"

     service_health {
      events    = ["Maintenance"]   # Missing "Incident"
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.notify_team.id
  }
}

resource "azurerm_monitor_activity_log_alert" "positive4_2" {
  name                = "ServiceHealthActivityLogAlert"
  resource_group_name = var.resource_group_name
  scopes              = [data.azurerm_subscription.current.id]
  description         = "Alert for Azure Service Health events"
  enabled             = true

  criteria {
    category = "ServiceHealth"

     service_health {
      events    = ["Informational", "ActionRequired"]  # Missing "Incident"
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.notify_team.id
  }
}

data "azurerm_subscription" "current" {}
