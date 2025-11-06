resource "azurerm_monitor_activity_log_alert" "positive2_5" {
  name                = "example-activitylogalert"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  scopes              = [azurerm_resource_group.example.id]
  description         = "Positive sample"

  criteria {
    resource_id    = azurerm_storage_account.to_monitor.id
    operation_name = "Microsoft.Authorization/policyAssignments/delete"
    category       = "Administrative"
    statuses       = ["Succeeded", "Failed"]                                        # filters by statuses
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
    }
}

resource "azurerm_monitor_activity_log_alert" "positive2_6" {
  name                = "example-activitylogalert"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  scopes              = [azurerm_resource_group.example.id]
  description         = "Positive sample"

  criteria {
    resource_id    = azurerm_storage_account.to_monitor.id
    operation_name = "Microsoft.Authorization/policyAssignments/delete"
    category       = "Administrative"
    sub_status     = "Accepted"                                                      # filters by sub_status
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
    }
}

resource "azurerm_monitor_activity_log_alert" "positive2_7" {
  name                = "example-activitylogalert"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  scopes              = [azurerm_resource_group.example.id]
  description         = "Positive sample"

  criteria {
    resource_id    = azurerm_storage_account.to_monitor.id
    operation_name = "Microsoft.Authorization/policyAssignments/delete"
    category       = "Administrative"
    sub_statuses   = ["Accepted", "Conflict"]                                         # filters by sub_statuses
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
    }
}
