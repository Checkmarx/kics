# Query prioritizes flagging the log alert(s) that is "correct" but missing the "action_group_id" field over all others
resource "azurerm_monitor_activity_log_alert" "positive4_1" {
  name                = "example-activitylogalert"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  scopes              = [azurerm_resource_group.example.id]
  description         = "Positive sample"

  criteria {
    resource_id    = azurerm_storage_account.to_monitor.id
    operation_name = "Microsoft.Security/securitySolutions/write"
    category       = "Administrative"
  }

  # Missing action block
}
