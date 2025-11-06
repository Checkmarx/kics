resource "azurerm_monitor_activity_log_alert" "positive6_2" {
  name                = "ServiceHealthActivityLogAlert"
  resource_group_name = var.resource_group_name
  scopes              = [data.azurerm_subscription.current.id]    # "current" subscription has a valid log alert
  description         = "Alert for Azure Service Health events"
  enabled             = true

  criteria {
    category = "ServiceHealth"

     service_health {
      events    = ["Incident"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.notify_team.id
  }
}
