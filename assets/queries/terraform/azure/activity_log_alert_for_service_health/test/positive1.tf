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
    category = "ServiceHealth"

     service_health {
      events    = ["Maintenance"]  # Missing 'Incident'
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.notify_team.id
  }
}

resource "azurerm_monitor_activity_log_alert" "positive1_3" {
  name                = "ServiceHealthActivityLogAlert"
  resource_group_name = var.resource_group_name
  scopes              = [data.azurerm_subscription.current.id]
  description         = "Alert for Azure Service Health events"
  enabled             = true

  criteria {
    category = "Security"  # Wrong category

     service_health {
      events    = ["Maintenance"] # Missing 'Incident'
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.notify_team.id
  }
}

resource "azurerm_monitor_activity_log_alert" "positive1_4" {
  name                = "ServiceHealthActivityLogAlert"
  resource_group_name = var.resource_group_name
  scopes              = [data.azurerm_subscription.current.id]
  description         = "Alert for Azure Service Health events"
  enabled             = true

  criteria {
    category = "Security"  # Wrong category

     service_health {
      # Missing 'events'
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.notify_team.id
  }
}

resource "azurerm_monitor_activity_log_alert" "positive1_5" {
  name                = "ServiceHealthActivityLogAlert"
  resource_group_name = var.resource_group_name
  scopes              = [data.azurerm_subscription.current.id]
  description         = "Alert for Azure Service Health events"
  enabled             = true

  criteria {
    category = "Security"  # Wrong category

      # Missing 'service_health'
  }

  action {
    action_group_id = azurerm_monitor_action_group.notify_team.id
  }
}
