package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

filter_fields := ["caller", "level", "levels", "status", "statuses", "sub_status", "sub_statuses"]

CxPolicy[result] {
	resources := input.document[i].resource.azurerm_monitor_activity_log_alert

	value := at_least_one_valid_log_alert(resources)
	value.result != "has_valid_log"

	results := get_results(value)[_]

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_monitor_activity_log_alert",
		"resourceName": tf_lib.get_resource_name(results.resource, results.name),
		"searchKey": sprintf("azurerm_monitor_activity_log_alert[%s].criteria", [results.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "A 'azurerm_monitor_activity_log_alert' resource monitoring create policy assignment events should be defined",
		"keyActualValue": results.keyActualValue,
		"searchLine": common_lib.build_search_line(["resource", "azurerm_monitor_activity_log_alert", results.name, "criteria"], [])
	}
}

at_least_one_valid_log_alert(resources) = {"result" : "has_valid_log", "logs": []} {
	resources[x].criteria.category == "Administrative"
	resources[x].criteria.operation_name == "Microsoft.Authorization/policyAssignments/write"
	not has_filter(resources[x].criteria)
	common_lib.valid_key(resources[x].criteria.action, "action_group_id")

} else = {"result" : "has_log_without_action", "logs": logs} {
	logs := {key: resources[key] |
		resources[key].criteria.category == "Administrative"
		resources[key].criteria.operation_name == "Microsoft.Authorization/policyAssignments/write"
		not has_filter(resources[key].criteria)}
	logs != {}

} else = {"result" : "has_log_with_filter", "logs": logs} {
	logs := {key: resources[key] |
		resources[key].criteria.category == "Administrative"
		resources[key].criteria.operation_name == "Microsoft.Authorization/policyAssignments/write"}
	logs != {}

} else = {"result" : "has_invalid_logs_only", "logs": resources}

get_results(value) = results {			# Case of one or more resources failing only due to not setting an action.action_group_id
	value.result == "has_log_without_action"

	results := [z | z := {
		"resource" : value.logs[name],
		"name" : name,
		"keyActualValue" : "The 'azurerm_monitor_activity_log_alert[%s]' resource monitors create policy assignment events but is missing an 'action.action_group_id' field"
	}]

} else = results {							# Case of one or more resources failing only due to filters
	value.result == "has_log_with_filter"

	results := [z | z := {
		"resource" : value.logs[name],
		"name" : name,
		"keyActualValue" : sprintf("The 'azurerm_monitor_activity_log_alert[%s]' resource monitors create policy assignment events but sets %d filter(s): %s",[name, count(filters),concat(",",filters)])
	}
	filters = get_filters(value.logs[name].criteria)
	]
} else = results {							# Case of all resources failing because of category and/or operation_name
	results := [z | z := {
		"resource" : value.logs[name],
		"name" : name,
		"keyActualValue" : "None of the 'azurerm_monitor_activity_log_alert' resources monitor create policy assignment events"
	}]
}

has_filter(criteria) {
	common_lib.valid_key(criteria, filter_fields[_])
}

get_filters(criteria) = [x |
  y := filter_fields[_]
  common_lib.valid_key(criteria, y)
  x := y
]
