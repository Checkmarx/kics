package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

filter_fields := ["caller", "level", "levels", "status", "statuses", "sub_status", "sub_statuses"]

CxPolicy[result] {
	resources := input.document[i].resource.azurerm_monitor_activity_log_alert

	not at_least_one_valid_log_alert(resources)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "azurerm_monitor_activity_log_alert",
		"resourceName": tf_lib.get_resource_name(resources[name], name),
		"searchKey": sprintf("azurerm_monitor_activity_log_alert[%s].criteria", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "A 'azurerm_monitor_activity_log_alert' resource monitoring create policy assignment events should be defined",
		"keyActualValue": "None of the 'azurerm_monitor_activity_log_alert' resources monitor create policy assignment events",
		"searchLine": common_lib.build_search_line(["resource", "azurerm_monitor_activity_log_alert", name, "criteria"], [])
	}
}

at_least_one_valid_log_alert(resources) {
	resources[x].criteria.category == "Administrative"
	resources[x].criteria.operation_name == "Microsoft.Authorization/policyAssignments/write"
	not has_filter(resources[x].criteria)
}

has_filter(criteria) {
	common_lib.valid_key(criteria, filter_fields[_])
}
