package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_security_center_subscription_pricing[name]

	tier := lower(resource.tier)
	tier == "free"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_security_center_subscription_pricing",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_security_center_subscription_pricing[%s].tier", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_security_center_subscription_pricing.%s.tier' is 'Standard'", [name]),
		"keyActualValue": sprintf("'azurerm_security_center_subscription_pricing.%s.tier' is 'Free'", [name]),
	}
}
