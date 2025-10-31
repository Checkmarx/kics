resource "azurerm_monitor_activity_log_alert" "positive1" {
  name                = "example-activitylogalert"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  scopes              = [azurerm_resource_group.example.id]
  description         = "Negative sample"

  criteria {
    resource_id    = azurerm_storage_account.to_monitor.id
    operation_name = "Microsoft.Storage/storageAccounts/write"          # wrong operation name
    category       = "Administrative"
  }
}

resource "azurerm_monitor_activity_log_alert" "positive2" {
  name                = "example-activitylogalert"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  scopes              = [azurerm_resource_group.example.id]
  description         = "Negative sample"

  criteria {
    resource_id    = azurerm_storage_account.to_monitor.id
    operation_name = "Microsoft.Authorization/policyAssignments/write"
    category       = "Policy"                                             # wrong category
  }
}

resource "azurerm_monitor_activity_log_alert" "positive3" {
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
}

resource "azurerm_monitor_activity_log_alert" "positive4" {
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
}

resource "azurerm_monitor_activity_log_alert" "positive5" {
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
}

resource "azurerm_monitor_activity_log_alert" "positive6" {
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
}

resource "azurerm_monitor_activity_log_alert" "positive7" {
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
}

resource "azurerm_monitor_activity_log_alert" "positive8" {
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
}

resource "azurerm_monitor_activity_log_alert" "positive9" {
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
}
