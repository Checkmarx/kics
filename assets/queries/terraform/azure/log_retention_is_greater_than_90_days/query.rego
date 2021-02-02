package Cx

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_network_watcher_flow_log[name]

	var := resource.retention_policy.days
	var < 90

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_network_watcher_flow_log[%s].retention_policy.days", [name]),
		"issueType": "WrongValue",
		"keyExpectedValue": sprintf("'%s.retention_policy.days' is bigger than 90)", [name]),
		"keyActualValue": sprintf("'retention_policy.days' is bigger than 90 [%d])", [var]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_network_watcher_flow_log[name]

	not resource.retention_policy

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_network_watcher_flow_log[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s.retention_policy' exists)", [name]),
		"keyActualValue": sprintf("'%s.retention_policy' doesn't exist)", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_network_watcher_flow_log[name]

	resource.retention_policy
	enabled := resource.retention_policy.enabled
	not enabled

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_network_watcher_flow_log[%s].retention_policy.enabled", [name]),
		"issueType": "WrongValue",
		"keyExpectedValue": sprintf("'%s.retention_policy' should be enabled)", [name]),
		"keyActualValue": sprintf("'%s.retention_policy' is disabled)", [name]),
	}
}
