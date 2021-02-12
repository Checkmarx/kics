package Cx

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_security_center_subscription_pricing[name]

	tier := lower(resource.tier)
	tier == "free"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_security_center_subscription_pricing[%s].tier", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_security_center_subscription_pricing.%s.tier' is 'Standard'", [name]),
		"keyActualValue": sprintf("'azurerm_security_center_subscription_pricing.%s.tier' is 'Free'", [name]),
	}
}
