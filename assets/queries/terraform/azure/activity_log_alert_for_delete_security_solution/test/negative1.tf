resource "azurerm_monitor_activity_log_alert" "negative1" {
  name                = "example-activitylogalert"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  scopes              = [azurerm_resource_group.example.id]
  description         = "Negative sample"

  criteria {
    resource_id    = azurerm_storage_account.to_monitor.id
    operation_name = "Microsoft.Security/securitySolutions/delete"
    category       = "Administrative"
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id

    webhook_properties = {
      from = "terraform"
    }
  }
}
