package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

required_logs := {"accounts", "Filesystem", "clusters", "notebook", "jobs"}

CxPolicy[result] {
	resource := input.document[i].resource["azurerm_databricks_workspace"][name]

	diagnostic_resources := [resource |
		resource := input.document[x].resource.azurerm_monitor_diagnostic_setting[_]
		contains(resource.target_resource_id, concat(".", ["azurerm_databricks_workspace", name, "id"]))]

	keyActualValue := get_results(resource, name, diagnostic_resources)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_databricks_workspace",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("azurerm_databricks_workspace[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'azurerm_databricks_workspace' should be associated with an 'azurerm_monitor_diagnostic_setting' resource with all required logs and a valid destination",
		"keyActualValue": keyActualValue,
		"searchLine": common_lib.build_search_line(["resource", "azurerm_databricks_workspace", name],[])
	}
}

get_results(resource, name, diagnostic_resources) = keyActualValue {		# not associated with a single diagnostic setting resource
	count(diagnostic_resources) == 0

	keyActualValue := "'azurerm_databricks_workspace' is not associated with an 'azurerm_monitor_diagnostic_setting' resource"

} else = keyActualValue {													# associated with 1+ diagnostic setting resource(s) without required logs
	diagnostics_with_relevant_logs(diagnostic_resources) == []

	keyActualValue := sprintf("'azurerm_databricks_workspace' is associated with %d 'azurerm_monitor_diagnostic_setting' resource(s), but none enable all required logs",[count(diagnostic_resources)])
} else = keyActualValue {
	valid_resources := diagnostics_with_relevant_logs(diagnostic_resources)
	not valid_destination(valid_resources)

	keyActualValue := sprintf("'azurerm_databricks_workspace' is associated with %d 'azurerm_monitor_diagnostic_setting' resource(s) with all required logs, but none have a valid destination set up",[count(diagnostic_resources)])
}

valid_destination(valid_resources) {
	destination_fields := ["log_analytics_workspace_id", "storage_account_id"]
	common_lib.valid_key(valid_resources[_], destination_fields[_])
} else {
	common_lib.valid_key(valid_resources[x], "eventhub_authorization_rule_id")
	common_lib.valid_key(valid_resources[x], "eventhub_name")
}

diagnostics_with_relevant_logs(diagnostic_resources) = valid_resources {
	valid_resources := [x |
			x := has_all_relevant_logs(diagnostic_resources[_])
			]
}

has_all_relevant_logs(resource) = resource {													# "enabled_log" as array
	is_array(resource.enabled_log)

	categories := [x | x := resource.enabled_log[_].category]
	missing_logs := [y | y := required_logs[_]; not common_lib.inArray(categories, y)]
	missing_logs == []

} else = resource {																			# "log" as array
	is_array(resource.log)

	enabled_logs := [x | x := resource.log[_]; x.enabled == true]
	categories := [y | y := enabled_logs[_].category]

	missing_logs := [z | z := required_logs[_]; not common_lib.inArray(categories, z)]
	missing_logs == []
}
