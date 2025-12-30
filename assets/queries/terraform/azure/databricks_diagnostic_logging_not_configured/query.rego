package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

required_logs := {"accounts", "Filesystem", "clusters", "notebook", "jobs"}

CxPolicy[result] {
	resource := input.document[i].resource.azurerm_databricks_workspace[name]

	diagnostic_resources := [resource |
		resource := input.document[x].resource.azurerm_monitor_diagnostic_setting[_]
		contains(resource.target_resource_id, concat(".", ["azurerm_databricks_workspace", name, "id"]))]

	keyActualValue := get_results(resource, diagnostic_resources)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_databricks_workspace",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_databricks_workspace[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'azurerm_databricks_workspace' should be associated with 'azurerm_monitor_diagnostic_setting' resources that log all required logs to valid destinations",
		"keyActualValue": keyActualValue,
		"searchLine": common_lib.build_search_line(["resource", "azurerm_databricks_workspace", name],[])
	}
}

get_results(resource, diagnostic_resources) = keyActualValue {				# not associated with a single diagnostic setting resource
	count(diagnostic_resources) == 0

	keyActualValue := "'azurerm_databricks_workspace' is not associated with an 'azurerm_monitor_diagnostic_setting' resource"

} else = keyActualValue {													# associated with 1+ diagnostic setting resource(s) but without all required logs
	logs_enabled := get_valid_enabled_logs(diagnostic_resources)
	missing_logs := required_logs - logs_enabled
	count(missing_logs) != 0

	keyActualValue := sprintf("'azurerm_databricks_workspace' is associated with %d 'azurerm_monitor_diagnostic_setting' resource(s), but is missing logs for %d category(s): '%v'",[count(diagnostic_resources), count(missing_logs) ,concat("', '", missing_logs)])
}

get_valid_enabled_logs(diagnostic_resources) = logs_enabled {
	logs_enabled := union({x | x := get_valid_logs(diagnostic_resources[_])})
}

get_valid_logs(resource) = valid_logs {													# "enabled_log" array
	is_array(resource.enabled_log)
	valid_destination(resource)
	valid_logs := {x | x := resource.enabled_log[i].category
					   resource.enabled_log[i].category == required_logs[_]}
} else = valid_logs {																	# "enabled_log" object
	common_lib.valid_key(resource, "enabled_log")
	valid_destination(resource)
	resource.enabled_log.category == required_logs[_]
	valid_logs := {resource.enabled_log.category}
} else = valid_logs {																			# "log" array
	is_array(resource.log)
	valid_destination(resource)
	valid_logs := {x | x := resource.log[i].category
					   resource.log[i].category == required_logs[_]
					   is_enabled(resource.log[i])}
} else = valid_logs {																			# "log" object
	common_lib.valid_key(resource, "log")
	valid_destination(resource)
	resource.log.category == required_logs[_]
	is_enabled(resource.log)
	valid_logs := {resource.log.category}
}

is_enabled(log) {
	log.enabled == true
} else {
	not common_lib.valid_key(log, "enabled")	# "enabled" defaults to true
}

valid_destination(resource) {
	destination_fields := ["log_analytics_workspace_id", "storage_account_id"]
	common_lib.valid_key(resource, destination_fields[_])
} else {
	common_lib.valid_key(resource, "eventhub_authorization_rule_id")
	common_lib.valid_key(resource, "eventhub_name")
}
