# Case of correct "service_health.events" and "category" but the "action.action_group_id" field is missing
resource "azurerm_monitor_activity_log_alert" "positive3_1" {
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

  # Missing action
}

data "azurerm_subscription" "current" {}
