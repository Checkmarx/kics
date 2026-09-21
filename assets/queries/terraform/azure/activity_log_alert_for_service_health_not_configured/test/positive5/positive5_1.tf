# Query prioritizes flagging the log alert(s) that is "correct" but missing the "action_group_id" field over all others
resource "azurerm_monitor_activity_log_alert" "positive5_1" {
  name                = "ServiceHealthActivityLogAlert"
  resource_group_name = var.resource_group_name
  scopes              = [data.azurerm_subscription.current.id]
  description         = "Alert for Azure Service Health events"
  enabled             = true

  criteria {
    category = "ServiceHealth"

     service_health {
      events    = ["Incident"]
    }
  }

  # Missing action block
}

resource "azurerm_monitor_activity_log_alert" "positive5_2" {
  name                = "ServiceHealthActivityLogAlert"
  resource_group_name = var.resource_group_name
  scopes              = [data.azurerm_subscription.current.id]
  description         = "Alert for Azure Service Health events"
  enabled             = true

  criteria {
    category = "ServiceHealth"

     service_health {
      events    = ["Maintenance"]  # Missing "Incident"
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.notify_team.id
  }
}

data "azurerm_subscription" "current" {}
