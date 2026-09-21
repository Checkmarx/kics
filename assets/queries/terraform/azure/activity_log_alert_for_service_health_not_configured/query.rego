package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resources     := {input.document[index].id : log_alerts | log_alerts := input.document[index].resource.azurerm_monitor_activity_log_alert}
	subscriptions := {input.document[index].id : subs       | subs := input.document[index].data.azurerm_subscription}

	subscriptions[doc_id][name]
	value := at_least_one_valid_log_alert(resources, name, doc_id)
	value.result != "has_valid_log"

	results := get_results(value)[_]
	dynamic_values := get_values(results)

	result := {
		"documentId": results.doc_id,
		"resourceType": "azurerm_monitor_activity_log_alert",
		"resourceName": dynamic_values.resourceName,
		"searchKey": dynamic_values.searchKey,
		"issueType": results.issueType,
		"keyExpectedValue": "A 'azurerm_monitor_activity_log_alert' resource that monitors 'ServiceHealth' events should be defined for each subscription",
		"keyActualValue": results.keyActualValue,
		"searchLine": dynamic_values.searchLine
	}
}

get_values(results) = dynamic_values {
	results.no_log == true
	dynamic_values := {
		"resourceName": "",
		"searchKey": sprintf("azurerm_subscription[%s]", [results.name]),
		"searchLine": common_lib.build_search_line(["data", "azurerm_subscription", results.name], [])
	}
} else = {
	"resourceName": tf_lib.get_resource_name(results.resource, results.name),
	"searchKey": sprintf("azurerm_monitor_activity_log_alert[%s].criteria", [results.name]),
	"searchLine": common_lib.build_search_line(["resource", "azurerm_monitor_activity_log_alert", results.name, "criteria"], [])
}

at_least_one_valid_log_alert(resources, subscription_name, doc_id_subs) = {"result" : "has_valid_log"} {
	resources[doc_index][x].scopes[_] == sprintf("${data.azurerm_subscription.%s.id}",[subscription_name])
	resources[doc_index][x].criteria.category == "ServiceHealth"
	resources[doc_index][x].criteria.service_health.events[_] == "Incident"
	common_lib.valid_key(resources[doc_index][x].action, "action_group_id")

} else = {"result" : "has_log_without_action", "logs": logs} {
	logs := {doc_index: filtered |
			resources[doc_index]
			filtered := {key: resource |
				resource := resources[doc_index][key]
				resource.scopes[_] == sprintf("${data.azurerm_subscription.%s.id}",[subscription_name])
				resource.criteria.category == "ServiceHealth"
				resource.criteria.service_health.events[_] == "Incident"}
		}
	logs[_] != {}

} else = {"result" : "has_log_without_incident_event", "logs": logs} {
	logs := {doc_index: filtered |
			resources[doc_index]
			filtered := {key: resource |
				resource := resources[doc_index][key]
				resource.scopes[_] == sprintf("${data.azurerm_subscription.%s.id}",[subscription_name])
				resource.criteria.category == "ServiceHealth"}
		}
	logs[_] != {}

} else = {"result" : "has_invalid_logs_only", "logs": logs} {
	logs := {doc_index: filtered |
			resources[doc_index]
			filtered := {key: resource |
				resource := resources[doc_index][key]
				resource.scopes[_] == sprintf("${data.azurerm_subscription.%s.id}",[subscription_name])}
		}
	logs[_] != {}
} else = {"result" : "no_logs", "subscription" : subscription_name, "doc_id": doc_id_subs}

get_results(value) = results {					# Case of one or more resources failing due to not setting an "action.action_group_id" field
	value.result == "has_log_without_action"

	results := [z |
		log := value.logs[doc_id][name]
		z := {
			"doc_id" : doc_id,
			"resource" : log,
			"name" : name,
			"issueType": "MissingAttribute",
			"keyActualValue" : sprintf("The 'azurerm_monitor_activity_log_alert[%s]' resource monitors 'ServiceHealth' events but is missing an 'action.action_group_id' field", [name])
		}]

} else = results {								# Case of one or more resources failing due to not including "Incident" in events array
	value.result == "has_log_without_incident_event"

	results := [z |
		log := value.logs[doc_id][name]
		z := {
			"doc_id" : doc_id,
			"resource" : log,
			"name" : name,
			"issueType": check_service_health_block_issue_type(log) ,
			"keyActualValue" : sprintf("The 'azurerm_monitor_activity_log_alert[%s]' resource monitors 'ServiceHealth' events but does not include 'Incident' in its 'criteria.service_health.events' array", [name])
		}]

} else = results {								# Case of all resources failing due to invalid category and/or operation_name
	value.result == "has_invalid_logs_only"

	results := [z |
		log := value.logs[doc_id][name]
		z := {
			"doc_id" : doc_id,
			"resource" : log,
			"name" : name,
			"issueType": "IncorrectValue",
			"keyActualValue" : "None of the 'azurerm_monitor_activity_log_alert' resources monitor 'ServiceHealth' events"
		}]
} else = results {								# Case of "subscription" defined without a single alert log associated with it
		name := value.subscription
		results := [{
			"doc_id" : value.doc_id,
			"name" : name,
			"issueType": "MissingAttribute",
			"keyActualValue" : sprintf("There is not a single 'azurerm_monitor_activity_log_alert' resource associated with the '%s' subscription", [name]),
			"no_log": true
		}]
}


check_service_health_block_issue_type(log) = "IncorrectValue"{	# If events array is set but does not include "Incident"
	common_lib.valid_key(log.criteria.service_health, "events")
} else = "MissingAttribute" # If "service_health" or "events" is undefined or null
