package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

required_logs := {"Administrative", "Alert", "Policy", "Security"}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_monitor_diagnostic_setting[name]

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

get_results(resource, name) = results { # missing "log" and "enabled_log" fields
	not common_lib.valid_key(resource, "log")
	not common_lib.valid_key(resource, "enabled_log")

	results := {
		"searchKey": sprintf("azurerm_monitor_diagnostic_setting[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].enabled_log' objects should be defined for all 4 main categories", [name]),
		"keyActualValue": sprintf("'azurerm_monitor_diagnostic_setting[%s]' does not define a single 'enabled_log' object", [name]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_monitor_diagnostic_setting", name], [])
	}
} else = results { 	# "enabled_log"/"log" as array or as object
	log_data := has_all_relevant_logs(resource)
	log_data.missing_logs != []

	results := {
		"searchKey": sprintf("azurerm_monitor_diagnostic_setting[%s]", [name]),
		"issueType": log_data.issueType,
		"keyExpectedValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].%s' objects should enable logging for all 4 main categories", [name, log_data.log_type]),
		"keyActualValue": sprintf("'azurerm_monitor_diagnostic_setting[%s].%s' objects do not enable logging for %d of the main categories: '%s'", [name, log_data.log_type, count(log_data.missing_logs), concat("', '",log_data.missing_logs)]),
		"searchLine": common_lib.build_search_line(["resource", "azurerm_monitor_diagnostic_setting", name], [])
	}

}

has_all_relevant_logs(resource) = log_data { 	# "enabled_log" as array
	is_array(resource.enabled_log)

	categories := [x | x := resource.enabled_log[_].category]
	missing_logs := [y | y := required_logs[_]; not common_lib.inArray(categories, y)]

	log_data := { "missing_logs" : missing_logs, "log_type" : "enabled_log", "issueType": "MissingAttribute"}

} else = log_data {																			# "enabled_log" as single object
	common_lib.valid_key(resource, "enabled_log")

	missing_logs := [y | y := required_logs[_]; y != resource.enabled_log.category]

	log_data := { "missing_logs" : missing_logs, "log_type" : "enabled_log", "issueType": "MissingAttribute"}

} else = log_data {																			# "log" as array
	is_array(resource.log)

	enabled_logs := [x | x := resource.log[_]; is_enabled(x)]
	categories := [y | y := enabled_logs[_].category]

	missing_logs := [z | z := required_logs[_]; not common_lib.inArray(categories, z)]


	log_data := { "missing_logs" : missing_logs, "log_type" : "log", "issueType": get_issue_type(resource.log)}

} else = log_data {
	is_enabled(resource.log)															# "log" as single "enabled" object
	missing_logs := [z | z := required_logs[_]; z != resource.log.category]

	log_data := { "missing_logs" : missing_logs, "log_type" : "log", "issueType": "MissingAttribute"}

} else = {"missing_logs" : required_logs, "log_type" : "log", "issueType": "IncorrectValue"}		# "log" as single "disabled" object

is_enabled(log) {
	log.enabled == true
} else {
	not common_lib.valid_key(log, "enabled")	# "enabled" defaults to true
}

get_issue_type(log) = "IncorrectValue" {	# If it sets a required log "enabled" field to not true
	log[x].category   == required_logs[_]
	log[x].enabled    != true
} else = "MissingAttribute"
