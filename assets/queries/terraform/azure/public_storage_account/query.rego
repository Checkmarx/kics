package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	network_rules := input.document[i].resource.azurerm_storage_account[name].network_rules

	network_rules.ip_rules[l] == "0.0.0.0/0"
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_storage_account[%s].network_rules.ip_rules", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'network_rules.ip_rules' does not contain 0.0.0.0/0",
		"keyActualValue": "'network_rules.ip_rules' contains 0.0.0.0/0",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", name, "network_rules", "ip_rules"], [l]),
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
		"keyExpectedValue": "'network_rules.ip_rules' is defined and not null",
		"keyActualValue": "'network_rules.default_action' is 'Allow' and 'network_rules.ip_rules' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", name, "network_rules"], []),
	}
}

CxPolicy[result] {
	rules := input.document[i].resource.azurerm_storage_account_network_rules[name]

	rules.ip_rules[l] == "0.0.0.0/0"
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_storage_account_network_rules[%s].ip_rules", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("ip_rules[%d] does not contain 0.0.0.0/0", [l]),
		"keyActualValue": sprintf("ip_rules[%d] contains 0.0.0.0/0", [l]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account_network_rules", name, "ip_rules"], [l]),
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
		"keyExpectedValue": "'ip_rules' is defined and not null",
		"keyActualValue": "'default_action' is set to 'Allow' and 'ip_rules' is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account_network_rules", name], []),
	}
}

CxPolicy[result] {
	storage := input.document[i].resource.azurerm_storage_account[name]

	storage.allow_blob_public_access != false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_storage_account[%s].allow_blob_public_access", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'allow_blob_public_access' is set to false or undefined",
		"keyActualValue": "'allow_blob_public_access' is set to true",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", name, "allow_blob_public_access"], []),
	}
}
