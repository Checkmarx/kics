package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	networkRules := input.document[i].resource.azurerm_storage_account[name].network_rules
	networkRules.default_action == "Allow"
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.azurerm_storage_account[name], name),
		"searchKey": sprintf("azurerm_storage_account[%s].network_rules.default_action", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Expected 'default_action' should be set to 'Deny'",
		"keyActualValue": "'default_action' is set to 'Allow'",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account", name, "network_rules", "default_action"], []),
		"remediation": json.marshal({
			"before": "Allow",
			"after": "Deny"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	networkRules := input.document[i].resource.azurerm_storage_account_network_rules[name]
	networkRules.default_action == "Allow"
	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_storage_account_network_rules",
		"resourceName": tf_lib.get_resource_name(networkRules, name),
		"searchKey": sprintf("azurerm_storage_account_network_rules[%s].default_action", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Expected 'default_action' should be set to 'Deny'",
		"keyActualValue": "'default_action' is set to 'Allow'",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_storage_account_network_rules", name, "default_action"], []),
		"remediation": json.marshal({
			"before": "Allow",
			"after": "Deny"
		}),
		"remediationType": "replacement",
	}
}
