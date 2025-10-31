
# Will only flag log alert that is correct but has filter(s)
resource "azurerm_monitor_activity_log_alert" "positive3_1" {
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
    level          = "Informational"                                              # filters by level
    status         = "Succeeded"                                                  # filters by status
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
    }
}

resource "azurerm_monitor_activity_log_alert" "positive3_2" {
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

  action {
    action_group_id = azurerm_monitor_action_group.main.id
    }
}
