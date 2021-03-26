package Cx

import data.generic.common as commonLib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_account[name]
	object.get(resource, "network_rules", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_storage_account[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'network_rules' is defined",
		"keyActualValue": "'network_rules' is not defined",
	}
}

CxPolicy[result] {
	network_rules := input.document[i].resource.azurerm_storage_account[name].network_rules
	object.get(network_rules, "bypass", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_storage_account[%s].network_rules", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'network_rules.bypass' is defined",
		"keyActualValue": "'network_rules.bypass' is not defined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_storage_account[name]
	bypass := resource.network_rules.bypass
	not commonLib.inArray(bypass, "AzureServices")

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
	object.get(resource, "bypass", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_storage_account_network_rules[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'bypass' is defined",
		"keyActualValue": "'bypass' is not defined",
	}
}

CxPolicy[result] {
	network_rules := input.document[i].resource.azurerm_storage_account_network_rules[name]
	bypass := network_rules.bypass
	not commonLib.inArray(bypass, "AzureServices")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_storage_account_network_rules[%s].bypass", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'bypass' contains 'AzureServices'",
		"keyActualValue": "'bypass' does not contain 'AzureServices'",
	}
}
