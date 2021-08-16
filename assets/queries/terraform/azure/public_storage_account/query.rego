package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	network_rules := input.document[i].resource.azurerm_storage_account[name].network_rules
	some l
	network_rules.ip_rules[l] == "0.0.0.0/0"
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_storage_account[%s].network_rules.ip_rules", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "network_rules.ip_rules does not contain 0.0.0.0/0",
		"keyActualValue": "network_rules.ip_rules contain 0.0.0.0/0",
	}
}

CxPolicy[result] {
	network_rules := input.document[i].resource.azurerm_storage_account[name].network_rules
	not common_lib.valid_key(network_rules, "ip_rules")
	network_rules.default_action == "Allow"
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_storage_account[%s].network_rules", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "network_rules.ip_rules is defined and not null",
		"keyActualValue": "network_rules.default_action is 'Allow' and ip_rules is undefined or null",
	}
}

CxPolicy[result] {
	rules := input.document[i].resource.azurerm_storage_account_network_rules[name]
	some l
	rules.ip_rules[l] == "0.0.0.0/0"
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_storage_account_network_rules[%s].ip_rules", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "network_rules.ip_rules does not contain 0.0.0.0/0",
		"keyActualValue": "network_rules.ip_rules contain 0.0.0.0/0",
	}
}

CxPolicy[result] {
	rules := input.document[i].resource.azurerm_storage_account_network_rules[name]
	not common_lib.valid_key(rules, "ip_rules")
	rules.default_action == "Allow"
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_storage_account_network_rules[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "azurerm_storage_account_network_rules.ip_rules is defined and not null",
		"keyActualValue": "azurerm_storage_account_network_rules.default_action is 'Allow' and ip_rules is undefined or null",
	}
}
