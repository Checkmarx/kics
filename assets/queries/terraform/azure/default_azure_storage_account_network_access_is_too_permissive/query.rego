package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	networkRules := input.document[i].resource.azurerm_storage_account[name].network_rules
	networkRules.default_action == "Allow"
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_storage_account[%s].network_rules.default_action", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Expected 'default_action' to be set to 'Deny'",
		"keyActualValue": "'default_action' is set to 'Allow'",
		"searchLine": common_lib.build_search_line(["resources", "azurerm_storage_account", name, "network_rules", "default_action"], []),
	}
}

CxPolicy[result] {
	networkRules := input.document[i].resource.azurerm_storage_account_network_rules[name]
	networkRules.default_action == "Allow"
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_storage_account_network_rules[%s].default_action", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Expected 'default_action' to be set to 'Deny'",
		"keyActualValue": "'default_action' is set to 'Allow'",
		"searchLine": common_lib.build_search_line(["resources", "azurerm_storage_account_network_rules", name, "default_action"], []),
	}
}
