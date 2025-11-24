data "azurerm_subscription" "positive1_1" {}

# Missing a "azurerm_monitor_diagnostic_setting" resource

data "azurerm_subscription" "positive1_2" {}

resource "azurerm_monitor_diagnostic_setting" "positive1_2" {
  name               = "incomplete-setting"
  target_resource_id = data.azurerm_subscription.not_positive1_2.id

}
