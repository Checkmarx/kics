data "azurerm_subscription" "negative" {}

resource "azurerm_monitor_diagnostic_setting" "negative_1" {
  name               = "incomplete-setting"
  target_resource_id = data.azurerm_subscription.negative.id

}
