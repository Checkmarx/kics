# Case of correct "operation_name" and "category" but the "action.action_group_id" field is missing
resource "azurerm_monitor_activity_log_alert" "positive3_2" {
  name                = "example-activitylogalert"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  scopes              = [azurerm_resource_group.example.id]
  description         = "Positive sample"

  criteria {
    resource_id    = azurerm_storage_account.to_monitor.id
    operation_name = "Microsoft.Network/networkSecurityGroups/write"
    category       = "Administrative"
  }

  action {
    # Missing action_group_id
    }
}
