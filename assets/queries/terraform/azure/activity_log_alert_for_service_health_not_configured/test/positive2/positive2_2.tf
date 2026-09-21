resource "azurerm_monitor_activity_log_alert" "positive2_3" {
  name                = "ServiceHealthActivityLogAlert"
  resource_group_name = var.resource_group_name
  scopes              = [data.azurerm_subscription.current.id]
  description         = "Alert for Azure Service Health events"
  enabled             = true

  criteria {
    category = "ServiceHealth"

      # Missing 'service_health'
  }

  action {
    action_group_id = azurerm_monitor_action_group.notify_team.id
  }
}
