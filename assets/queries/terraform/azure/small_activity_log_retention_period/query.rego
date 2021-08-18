package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	monitor := input.document[i].resource.azurerm_monitor_log_profile[name]

	monitor.retention_policy.enabled == true
	not common_lib.valid_key(monitor.retention_policy, "days")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_monitor_log_profile[%s].retention_policy", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_monitor_log_profile[%s].retention_policy.days' is defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_monitor_log_profile[%s].retention_policy.days' is undefined or null", [name]),
	}
}

CxPolicy[result] {
	monitor := input.document[i].resource.azurerm_monitor_log_profile[name]

	monitor.retention_policy.enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_monitor_log_profile[%s].retention_policy.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_monitor_log_profile[%s].retention_policy.enabled' is set to true", [name]),
		"keyActualValue": sprintf("'azurerm_monitor_log_profile[%s].retention_policy.enabled' is set to false", [name]),
	}
}

CxPolicy[result] {
	monitor := input.document[i].resource.azurerm_monitor_log_profile[name]

	retentionPolicy := monitor.retention_policy
	retentionPolicy.enabled == true
	common_lib.between(retentionPolicy.days, 1, 364)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("azurerm_monitor_log_profile[%s].retention_policy.days", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_monitor_log_profile[%s].retention_policy.days' is greater than or equal to 365 days or 0 (indefinitely)", [name]),
		"keyActualValue": sprintf("'azurerm_monitor_log_profile[%s].retention_policy.days' is lesser than 365 days or different than 0 (indefinitely)", [name]),
	}
}
