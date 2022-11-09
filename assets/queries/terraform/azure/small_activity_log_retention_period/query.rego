package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	monitor := input.document[i].resource.azurerm_monitor_log_profile[name]

	monitor.retention_policy.enabled == true
	not common_lib.valid_key(monitor.retention_policy, "days")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_monitor_log_profile",
		"resourceName": tf_lib.get_resource_name(monitor, name),
		"searchKey": sprintf("azurerm_monitor_log_profile[%s].retention_policy", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_monitor_log_profile[%s].retention_policy.days' should be defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_monitor_log_profile[%s].retention_policy.days' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_monitor_log_profile",name, "retention_policy"], []),
		"remediation": "days = 365",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	monitor := input.document[i].resource.azurerm_monitor_log_profile[name]

	monitor.retention_policy.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_monitor_log_profile",
		"resourceName": tf_lib.get_resource_name(monitor, name),
		"searchKey": sprintf("azurerm_monitor_log_profile[%s].retention_policy.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_monitor_log_profile[%s].retention_policy.enabled' should be set to true", [name]),
		"keyActualValue": sprintf("'azurerm_monitor_log_profile[%s].retention_policy.enabled' is set to false", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_monitor_log_profile",name, "retention_policy","enabled"], []),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	monitor := input.document[i].resource.azurerm_monitor_log_profile[name]

	retentionPolicy := monitor.retention_policy
	retentionPolicy.enabled == true
	common_lib.between(retentionPolicy.days, 1, 364)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_monitor_log_profile",
		"resourceName": tf_lib.get_resource_name(monitor, name),
		"searchKey": sprintf("azurerm_monitor_log_profile[%s].retention_policy.days", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_monitor_log_profile[%s].retention_policy.days' should be greater than or equal to 365 days or 0 (indefinitely)", [name]),
		"keyActualValue": sprintf("'azurerm_monitor_log_profile[%s].retention_policy.days' is less than 365 days or different than 0 (indefinitely)", [name]),
		"searchLine": common_lib.build_search_line(["resource","azurerm_monitor_log_profile",name, "retention_policy","days"], []),
		"remediation": json.marshal({
			"before": sprintf("%d", [retentionPolicy.days]),
			"after": "365"
		}),
		"remediationType": "replacement",
	}
}
