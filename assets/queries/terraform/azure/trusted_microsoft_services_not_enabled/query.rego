package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_account[name]
	not common_lib.valid_key(resource, "network_rules")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_storage_account[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'network_rules' is defined and not null",
		"keyActualValue": "'network_rules' is undefined or null",
	}
}

CxPolicy[result] {
	network_rules := input.document[i].resource.azurerm_storage_account[name].network_rules
	not common_lib.valid_key(network_rules, "bypass")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_storage_account[%s].network_rules", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'network_rules.bypass' is defined and not null",
		"keyActualValue": "'network_rules.bypass' is undefined or null",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_account[name]
	bypass := resource.network_rules.bypass
	not common_lib.inArray(bypass, "AzureServices")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_storage_account[%s].network_rules.bypass", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'network_rules.bypass' contains 'AzureServices'",
		"keyActualValue": "'network_rules.bypass' does not contain 'AzureServices'",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_account_network_rules[name]
	not common_lib.valid_key(resource, "bypass")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_storage_account_network_rules[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'bypass' is defined and not null",
		"keyActualValue": "'bypass' is undefined or null",
	}
}

CxPolicy[result] {
	network_rules := input.document[i].resource.azurerm_storage_account_network_rules[name]
	bypass := network_rules.bypass
	not common_lib.inArray(bypass, "AzureServices")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_storage_account_network_rules[%s].bypass", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'bypass' contains 'AzureServices'",
		"keyActualValue": "'bypass' does not contain 'AzureServices'",
	}
}
