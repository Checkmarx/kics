# Query prioritizes flagging the log alert(s) that is "correct" but has filter(s) over the ones with wrong "operation_name"/"category"
resource "azurerm_monitor_activity_log_alert" "positive4_1" {
  name                = "example-activitylogalert"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  scopes              = [azurerm_resource_group.example.id]
  description         = "Positive sample"

  criteria {
    resource_id    = azurerm_storage_account.to_monitor.id
    operation_name = "Microsoft.Sql/servers/firewallRules/delete"
    category       = "Administrative"
    caller         = "admin@contoso.com"                                          # filters by caller
    level          = "Informational"                                              # filters by level
    status         = "Succeeded"                                                  # filters by status
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
    }
}
