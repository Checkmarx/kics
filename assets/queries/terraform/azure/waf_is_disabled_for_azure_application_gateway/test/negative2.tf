resource "azurerm_application_gateway" "negative2" {
  name                = "ag-aks"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  firewall_policy_id  = azurerm_web_application_firewall_policy.waf_policy.id

  sku {
    name = "WAF_v2"
    tier = "WAF_v2"
  }
}
