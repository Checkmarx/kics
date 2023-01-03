package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_network_watcher_flow_log[name]

	var := resource.retention_policy.days
	var < 90

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_network_watcher_flow_log",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_network_watcher_flow_log[%s].retention_policy.days", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.retention_policy.days' should be bigger than 90)", [name]),
		"keyActualValue": sprintf("'retention_policy.days' is less than 90 [%d])", [var]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_network_watcher_flow_log", name, "retention_policy", "days"], []),
		"remediation": json.marshal({
			"before": sprintf("%d", [resource.retention_policy.days]),
			"after": "90"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_network_watcher_flow_log[name]

	not common_lib.valid_key(resource, "retention_policy")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_network_watcher_flow_log",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_network_watcher_flow_log[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s.retention_policy' should exist)", [name]),
		"keyActualValue": sprintf("'%s.retention_policy' doesn't exist)", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_network_watcher_flow_log", name], []),
		"remediation": "retention_policy {\n\t\tenabled = true\n\t\tdays = 90\n\t}\n",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_network_watcher_flow_log[name]

	resource.retention_policy
	enabled := resource.retention_policy.enabled
	enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_network_watcher_flow_log",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_network_watcher_flow_log[%s].retention_policy.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.retention_policy' should be enabled)", [name]),
		"keyActualValue": sprintf("'%s.retention_policy' is disabled)", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_network_watcher_flow_log", name, "retention_policy", "enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
