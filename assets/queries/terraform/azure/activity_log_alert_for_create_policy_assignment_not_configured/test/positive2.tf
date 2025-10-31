
resource "azurerm_monitor_activity_log_alert" "positive2_1" {
  name                = "example-activitylogalert"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  scopes              = [azurerm_resource_group.example.id]
  description         = "Negative sample"

  criteria {
    resource_id    = azurerm_storage_account.to_monitor.id
    operation_name = "Microsoft.Authorization/policyAssignments/write"
    category       = "Administrative"
    caller         = "admin@contoso.com"                                          # filters by caller
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
    }
}

resource "azurerm_monitor_activity_log_alert" "positive2_2" {
  name                = "example-activitylogalert"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  scopes              = [azurerm_resource_group.example.id]
  description         = "Negative sample"

  criteria {
    resource_id    = azurerm_storage_account.to_monitor.id
    operation_name = "Microsoft.Authorization/policyAssignments/write"
    category       = "Administrative"
    level          = "Informational"                                              # filters by level
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
    }
}

resource "azurerm_monitor_activity_log_alert" "positive2_3" {
  name                = "example-activitylogalert"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  scopes              = [azurerm_resource_group.example.id]
  description         = "Negative sample"

  criteria {
    resource_id    = azurerm_storage_account.to_monitor.id
    operation_name = "Microsoft.Authorization/policyAssignments/write"
    category       = "Administrative"
    levels         = ["Informational", "Warning"]                                  # filters by levels
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
    }
}

resource "azurerm_monitor_activity_log_alert" "positive2_4" {
  name                = "example-activitylogalert"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  scopes              = [azurerm_resource_group.example.id]
  description         = "Negative sample"

  criteria {
    resource_id    = azurerm_storage_account.to_monitor.id
    operation_name = "Microsoft.Authorization/policyAssignments/write"
    category       = "Administrative"
    status         = "Succeeded"                                                    # filters by status
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
    }
}

resource "azurerm_monitor_activity_log_alert" "positive2_5" {
  name                = "example-activitylogalert"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  scopes              = [azurerm_resource_group.example.id]
  description         = "Negative sample"

  criteria {
    resource_id    = azurerm_storage_account.to_monitor.id
    operation_name = "Microsoft.Authorization/policyAssignments/write"
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
  description         = "Negative sample"

  criteria {
    resource_id    = azurerm_storage_account.to_monitor.id
    operation_name = "Microsoft.Authorization/policyAssignments/write"
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
  description         = "Negative sample"

  criteria {
    resource_id    = azurerm_storage_account.to_monitor.id
    operation_name = "Microsoft.Authorization/policyAssignments/write"
    category       = "Administrative"
    sub_statuses   = ["Accepted", "Conflict"]                                         # filters by sub_statuses
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
    }
}
