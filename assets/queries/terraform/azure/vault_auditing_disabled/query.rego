package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

required_logs := {"audit", "allLogs"}

CxPolicy[result] {
	resource := input.document[i].resource[types[t]][name]


	diagnostic_resources := [resource |
		resource := input.document[x].resource.azurerm_monitor_diagnostic_setting[_]
		contains(resource.target_resource_id, concat(".", ["azurerm_key_vault", name, "id"]))]

	keyActualValue := get_results(resource, name, diagnostic_resources)

	result := {
		"documentId": input.document[i].id,
		"resourceType": types[t],
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("%s[%s]", [types[t], name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'azurerm_key_vault' should be associated with an 'azurerm_monitor_diagnostic_setting' resource with 'audit' and 'allLogs' log categories enabled",
		"keyActualValue": keyActualValue,
		"searchLine": common_lib.build_search_line(["resource", "azurerm_key_vault", name],[])
	}
}

get_results(resource, name, diagnostic_resources) = keyActualValue {		# not associated with a single diagnostic setting resource
	count(diagnostic_resources) == 0

	keyActualValue := "'azurerm_key_vault' is not associated with a 'azurerm_monitor_diagnostic_setting' resource"

} else = keyActualValue {													# associated with 1+ diagnostic setting resource(s) without required logs
	not at_least_one_diagnostics_with_relevant_logs(diagnostic_resources)

	keyActualValue := sprintf("'azurerm_key_vault' is associated with %d 'azurerm_monitor_diagnostic_setting' resource(s), but none enable 'audit' and 'allLogs'",[count(diagnostic_resources)])
}

at_least_one_diagnostics_with_relevant_logs(diagnostic_resources) {
	has_all_relevant_logs(diagnostic_resources[_])
}

has_all_relevant_logs(resource) {							# "log" or "enabled_log" as single object
	not is_array(resource.log)
	not is_array(resource.enabled_log)

} else {													# "enabled_log" as array
	is_array(resource.enabled_log)

	categories := [x | x := resource.enabled_log[_].category_group]
	missing_logs := [y | y := required_logs[_]; not common_lib.inArray(categories, y)]
	missing_logs == []

} else {																			# "log" as array
	is_array(resource.log)

	enabled_logs := [x | x := resource.log[_]; x.enabled == true]
	categories := [y | y := enabled_logs[_].category_group]

	missing_logs := [z | z := required_logs[_]; not common_lib.inArray(categories, z)]
	missing_logs == []
}
