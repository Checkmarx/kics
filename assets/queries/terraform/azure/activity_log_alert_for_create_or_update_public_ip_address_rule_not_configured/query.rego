package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

filter_fields := ["caller", "level", "levels", "status", "statuses", "sub_status", "sub_statuses"]

CxPolicy[result] {
	resources := {input.document[index].id : log_alerts |
            log_alerts := input.document[index].resource.azurerm_monitor_activity_log_alert
            }

	value := at_least_one_valid_log_alert(resources)
	value.result != "has_valid_log"

	results := get_results(value)[_]

	result := {
		"documentId": results.doc_id,
		"resourceType": "azurerm_monitor_activity_log_alert",
		"resourceName": tf_lib.get_resource_name(results.resource, results.name),
		"searchKey": sprintf("azurerm_monitor_activity_log_alert[%s].criteria", [results.name]),
		"issueType": results.issueType,
		"keyExpectedValue": "A 'azurerm_monitor_activity_log_alert' resource that monitors 'create or update public ip address rule' events should be defined",
		"keyActualValue": results.keyActualValue,
		"searchLine": common_lib.build_search_line(["resource", "azurerm_monitor_activity_log_alert", results.name, "criteria"], [])
	}
}

at_least_one_valid_log_alert(resources) = {"result" : "has_valid_log"} {
	resources[doc_index][x].criteria.category == "Administrative"
	resources[doc_index][x].criteria.operation_name == "Microsoft.Network/publicIPAddresses/write"
	not has_filter(resources[doc_index][x].criteria)
	common_lib.valid_key(resources[doc_index][x].action, "action_group_id")

} else = {"result" : "has_log_without_action", "logs": logs} {
	logs := {doc_index: filtered |
			resources[doc_index]
			filtered := {key: resource |
				resource := resources[doc_index][key]
				resource.criteria.category == "Administrative"
				resource.criteria.operation_name == "Microsoft.Network/publicIPAddresses/write"
				not has_filter(resource.criteria)}
		}
	logs[_] != {}

} else = {"result" : "has_log_with_filter", "logs": logs} {
	logs := {doc_index: filtered |
			resources[doc_index]
			filtered := {key: resource |
				resource := resources[doc_index][key]
				resource.criteria.category == "Administrative"
				resource.criteria.operation_name == "Microsoft.Network/publicIPAddresses/write"}
		}
	logs[_] != {}

}

get_results(value) = results {					# Case of one or more resources failing due to not setting an "action.action_group_id" field
	value.result == "has_log_without_action"

	results := [z |
		log := value.logs[doc_id][name]
		z := {
			"doc_id" : doc_id,
			"resource" : log,
			"issueType": "MissingAttribute",
			"name" : name,
			"keyActualValue" : sprintf("The 'azurerm_monitor_activity_log_alert[%s]' resource monitors 'create or update public ip address rule' events but is missing an 'action.action_group_id' field", [name])
		}]

} else = results {								# Case of one or more resources failing due to setting filter(s)
	value.result == "has_log_with_filter"

	results := [z |
		filters = get_filters(value.logs[doc_id][name].criteria)
		z := {
			"doc_id" : doc_id,
			"resource" : value.logs[doc_id][name],
			"issueType": "IncorrectValue",
			"name" : name,
			"keyActualValue" : sprintf("The 'azurerm_monitor_activity_log_alert[%s]' resource monitors 'create or update public ip address rule' events but sets %d filter(s): %s", [name, count(filters),concat(", ",filters)])
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
