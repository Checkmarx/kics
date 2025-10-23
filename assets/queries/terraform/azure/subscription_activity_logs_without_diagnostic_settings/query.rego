package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_monitor_diagnostic_setting[name]

	target_is_subscription(resource.target_resource_id)
	results := get_results(resource, name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_monitor_diagnostic_setting",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": results.searchKey,
		"issueType": results.issueType,
		"keyExpectedValue": results.keyExpectedValue,
		"keyActualValue": results.keyActualValue,
		"searchLine": results.searchLine
	}
}

get_results(resource, name) = results { # missing "log" field
	not common_lib.valid_key(resource, "log")

	results := {
		"searchKey": sprintf("azurerm_monitor_diagnostic_setting[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].log' should be defined and not null", [name]),
		"keyActualValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].log' is undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_monitor_diagnostic_setting", name], [])
	}
} else = results { 	# log array
	is_array(resource.log)
	not at_least_one_enabled_log(resource.log)

	results := {
		"searchKey": sprintf("azurerm_monitor_diagnostic_setting[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].log' should be defined and enable at least one log category", [name]),
		"keyActualValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].log' has all its log blocks(%d) disabled", [name, count(resource.log)]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_monitor_diagnostic_setting", name], [])
	}
} else = results {	# single log object
	resource.log.enabled != true

	results := {
		"searchKey": sprintf("azurerm_monitor_diagnostic_setting[%s].log", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].log' should be defined and set 'enabled' to 'true'", [name]),
		"keyActualValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].log' sets 'enabled' to '%s'", [name, resource.log.enabled]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_monitor_diagnostic_setting", name, "log"], [])
	}
}

target_is_subscription(id) {
	regex.match("^/subscriptions/[0-9a-fA-F-]{36}$", id)
} else {
	regex.match("^/subscriptions/\\$\\{[^}]+\\}$", id)
}

at_least_one_enabled_log(log) {
	log[_].enabled == true
}
