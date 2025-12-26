package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

types := {"google_logging_metric", "google_monitoring_alert_policy"}
regex_pattern := "^\\s*resource\\.type\\s*=\\s*\\\"iam_role\\\"\\s*AND\\s*\\(\\s*protoPayload\\.methodName\\s*=\\s*\\\"google\\.iam\\.admin\\.v1\\.CreateRole\\\"\\s*OR\\s*protoPayload\\.methodName\\s*=\\s*\\\"google\\.iam\\.admin\\.v1\\.DeleteRole\\\"\\s*OR\\s*protoPayload\\.methodName\\s*=\\s*\\\"google\\.iam\\.admin\\.v1\\.UpdateRole\\\"\\s*OR\\s*protoPayload\\.methodName\\s*=\\s*\\\"google\\.iam\\.admin\\.v1\\.UndeleteRole\\\"\\s*\\)\\s*$"

CxPolicy[result] {
	log_resources := [{"value": object.get(input.document[index].resource, "google_logging_metric", []), "document_index": index}]
	alert_resources := [{"value": object.get(input.document[index].resource, "google_monitoring_alert_policy", []), "document_index": index}]
	results := not_one_valid_log_and_alert_pair(log_resources, alert_resources)

	result := {
		"documentId": results[i].documentId,
		"resourceType": results[i].resourceType,
		"resourceName": results[i].resourceName,
		"searchKey": results[i].searchKey,
		"issueType": results[i].issueType,
		"keyExpectedValue": results[i].keyExpectedValue,
		"keyActualValue": results[i].keyActualValue,
		"searchLine": results[i].searchLine
	}
}

not_one_valid_log_and_alert_pair(log_resources, alert_resources) = results {
	log_resources[_].value != []
	logs_filters_data := [log | log := get_data(log_resources[_].value[name_log], "google_logging_metric", name_log, log_resources[_].document_index)]

	not single_regex_match(logs_filters_data)

	results := [res | res := {
		"documentId": input.document[logs_filters_data[i].doc_index].id,
		"resourceType": "google_logging_metric",
		"resourceName": tf_lib.get_resource_name(logs_filters_data[i].resource, logs_filters_data[i].name),
		"searchKey": sprintf("google_logging_metric[%s].%s", [logs_filters_data[i].name, logs_filters_data[i].path]),
		"issueType":  "IncorrectValue",
		"keyExpectedValue": "At least one 'google_logging_metric' resource should capture all custom role changes",
		"keyActualValue": "No 'google_logging_metric' resource captures all custom role changes",
		"searchLine": common_lib.build_search_line(logs_filters_data[i].searchArray, [])
	}]

} else = results {
	log_resources[_].value != []
	alert_resources[_].value != []
	logs_filters_data := [log | log := get_data(log_resources[_].value[name_log], "google_logging_metric", name_log, log_resources[_].document_index)]

	valid_logs_names := [logs_filters_data[i2].name |
  		regex.match(regex_pattern, logs_filters_data[i2].filter)
	]

	alerts_filters_data := [alert | alert := get_data(alert_resources[_].value[name_al], "google_monitoring_alert_policy", name_al, log_resources[_].document_index)]

	value := has_regex_match_or_reference(alerts_filters_data, valid_logs_names)

	results := get_results(alerts_filters_data, value)
} else = results {
    alert_resources[_].value != []
    not at_least_one_log(log_resources)

	alerts_filters_data := [alert | alert := get_data(alert_resources[_].value[name_al], "google_monitoring_alert_policy", name_al, log_resources[_].document_index)]

	value := has_regex_match_or_reference(alerts_filters_data, [])

	results := get_results(alerts_filters_data, value)
}

get_data(resource, type, name, doc_index) = filter {
	type == "google_logging_metric"
	filter := {
		"resource" : resource,
		"filter" : resource.filter,
		"path" : "filter",
		"searchArray" : ["resource", type, name],
		"name" : name,
		"doc_index" : doc_index
	}
} else = filter {
	# google_monitoring_alert_policy
	filter := {
		"resource" : resource,
		"filter" : resource.conditions.condition_threshold.filter,			# prefered filter (allows referencing)
		"path" : "conditions.condition_threshold.filter",
		"searchArray" : ["resource", type, name],
		"name" : name,
		"doc_index" : doc_index,
		"allows_ref" : true
	}
} else = filter {
	filter := {
		"resource" : resource,
		"filter" : resource.conditions.condition_matched_log.filter,
		"path" : "conditions.condition_matched_log.filter",
		"searchArray" : ["resource", type, name],
		"name" : name,
		"doc_index" : doc_index,
		"allows_ref" : false
	}
}

single_regex_match(filters_data) {
	regex.match(regex_pattern, filters_data[_].filter)
}

has_regex_match_or_reference(alerts_filters_data, valid_logs_names) = true {
	regex.match(regex_pattern, alerts_filters_data[i].filter)
	alerts_filters_data[i].resource.notification_channels
} else = true {
	alerts_filters_data[i].allows_ref == true
	alerts_filters_data[i].resource.notification_channels
	contains(alerts_filters_data[i].filter, sprintf("logging.googleapis.com/user/%s",[valid_logs_names[_]]))
} else = index {
	regex.match(regex_pattern, alerts_filters_data[index].filter)
} else = index {
	alerts_filters_data[index].allows_ref == true
	contains(alerts_filters_data[index].filter, sprintf("logging.googleapis.com/user/%s",[valid_logs_names[_]]))
} else = false

get_results(alerts_filters_data, value) = results {
	value == false
	results := [res | res := {
			"documentId": input.document[alerts_filters_data[i].doc_index].id,
			"resourceType": "google_monitoring_alert_policy",
			"resourceName": tf_lib.get_resource_name(alerts_filters_data[i].resource, alerts_filters_data[i].name),
			"searchKey": sprintf("google_monitoring_alert_policy[%s].%s", [alerts_filters_data[i].name, alerts_filters_data[i].path]),
			"issueType":  "IncorrectValue",
			"keyExpectedValue": "At least one 'google_monitoring_alert_policy' resource should capture all custom role changes",
			"keyActualValue": "No 'google_monitoring_alert_policy' resource captures all custom role changes",
			"searchLine": common_lib.build_search_line(alerts_filters_data[i].searchArray, [])
		}]
} else = results {
	is_number(value)
	results := [res | res := {
			"documentId": input.document[alerts_filters_data[value].doc_index].id,
			"resourceType": "google_monitoring_alert_policy",
			"resourceName": tf_lib.get_resource_name(alerts_filters_data[value].resource, alerts_filters_data[value].name),
			"searchKey": sprintf("google_monitoring_alert_policy[%s]", [alerts_filters_data[value].name]),
			"issueType":  "IncorrectValue",
			"keyExpectedValue": "At least one 'google_monitoring_alert_policy' resource should capture all custom role changes",
			"keyActualValue": sprintf("The 'google_monitoring_alert_policy[%s]' resource captures all custom role changes but does not define a proper 'notification_channels'",[alerts_filters_data[value].name]),
			"searchLine": common_lib.build_search_line(alerts_filters_data[value].searchArray, [])
		}]
}

at_least_one_log(log_resources) {
	log_resources[_].value != []
}
