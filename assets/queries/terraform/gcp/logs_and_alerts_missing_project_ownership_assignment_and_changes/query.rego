package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

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
	logs_filters_data := [log | log := get_data(log_resources[_].value[log_name], "google_logging_metric", log_name, log_resources[_].document_index)]
	results := [res | filters_data := logs_filters_data[i]
		keyActualValue := single_match(filters_data)
		keyActualValue != null
		res := {
			"documentId": input.document[logs_filters_data[i].doc_index].id,
			"resourceType": "google_logging_metric",
			"resourceName": tf_lib.get_resource_name(logs_filters_data[i].resource, logs_filters_data[i].name),
			"searchKey": sprintf("google_logging_metric[%s].%s", [logs_filters_data[i].name, logs_filters_data[i].path]),
			"issueType":  "IncorrectValue",
			"keyExpectedValue": "At least one 'google_logging_metric' resource should capture project ownership assignment and changes",
			"keyActualValue": "No 'google_logging_metric' resource captures project ownership assignment and changes",
			"searchLine": common_lib.build_search_line(logs_filters_data[i].searchArray, [])
		}]
	count(results) == count(logs_filters_data) # if a single filter is valid it should not flag
} else = results {
	log_resources[_].value != []
	alert_resources[_].value != []
	logs_filters_data := [log | log := get_data(log_resources[_].value[log_name], "google_logging_metric", log_name, log_resources[_].document_index)]

	valid_logs_names := [logs_filters_data[i2].name |
		lines := process_filter(logs_filters_data[i2].filter)
		is_improper_filter(lines) == null
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

single_match(filters_data) = keyActualValue {
	lines := process_filter(filters_data.filter)
	keyActualValue := is_improper_filter(lines)	
}

has_regex_match_or_reference(alerts_filters_data, valid_logs_names) = true {
	lines := process_filter(alerts_filters_data[i].filter)
	is_improper_filter(lines) == null
	alerts_filters_data[i].resource.notification_channels
} else = true {
	alerts_filters_data[i].allows_ref == true
	alerts_filters_data[i].resource.notification_channels
	contains(alerts_filters_data[i].filter, sprintf("logging.googleapis.com/user/%s",[valid_logs_names[_]]))
} else = index {
	lines := process_filter(alerts_filters_data[index].filter)
	is_improper_filter(lines) == null
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
			"keyExpectedValue": "At least one 'google_monitoring_alert_policy' resource should capture project ownership assignment and changes",
			"keyActualValue": "No 'google_monitoring_alert_policy' resource captures project ownership assignment and changes",
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
			"keyExpectedValue": "At least one 'google_monitoring_alert_policy' resource should capture project ownership assignment and changes",
			"keyActualValue": sprintf("The 'google_monitoring_alert_policy[%s]' resource captures project ownership assignment and changes but does not define a proper 'notification_channels'",[alerts_filters_data[value].name]),
			"searchLine": common_lib.build_search_line(alerts_filters_data[value].searchArray, [])
		}]
}

# definir aqui algo como o is_improper_filter
is_improper_filter(lines) = keyActualValue { # serviceName not defined to 'cloudresourcemanager.googleapis.com'
	not correct_proto_payload_service_name(lines)
	keyActualValue := "is applied to the wrong serviceName"
} else = keyActualValue {
	not has_project_ownership_or_invitee(lines) # does not have ProjectOwnership or projectOwnerInvitee
	keyActualValue := "is not applied to ProjectOwnershop or projectOwnerInvitee"
} else = keyActualValue { # bindingDeltas.action not defined to "REMOVED" and "ADD" for bingingDeltas.role="roles/owner"
	not has_add_or_remove_owner_or(lines) 
	keyActualValue := "does not bind both the actions 'REMOVE' and 'ADD' to 'roles/owner' role"
} else = null

process_filter(raw_filter) = lines {
	normalized := normalize_filter(raw_filter)
	marked := regex.replace(normalized, "\\)\\s+(AND|OR)\\s+\\(", ")\n$1(")
	lines := split(marked, "\n")
}

normalize_filter(raw_filter) = normalized {
	step1 := regex.replace(raw_filter, "\\n", " ")
	step2 := regex.replace(step1, "\\s+", " ")
	step3 := regex.replace(step2, "\\(\\s+", "(")
	step4 := regex.replace(step3, "\\s+\\)", ")")
	step5 := regex.replace(step4, "\\s+AND\\s+", " AND ")
    step6 := regex.replace(step5, "\\s+OR\\s+", " OR ")
	normalized := regex.replace(step6, "\\s*=\\s*", "=")
}

correct_proto_payload_service_name(lines) {
	regex.match("(?i)protoPayload\\.serviceName\\s*=\\s*(\\(((\\s*OR\\s*)?\".+\"(\\s*OR\\s*)?)*)?\"cloudresourcemanager.googleapis.com\"", concat("", lines))
} else {
	regex.match("(?i)NOT\\s*protoPayload\\.serviceName\\s*!=\\s*\"cloudresourcemanager.googleapis.com\"", concat("", lines))
}

has_project_ownership_or_invitee(lines) {
	regex.match("(?i)\\(\\s*(ProjectOwnership\\s*OR\\s*projectOwnerInvitee|projectOwnerInvitee\\s*OR\\s*ProjectOwnership)\\s*\\)", concat("", lines))
}

has_add_or_remove_owner_or(lines) {
	has_or_add_owner(lines)
	has_or_remove_owner(lines)
}

has_or_add_owner(lines) {
	line := lines[_]
	startswith(trim(line, " "), "OR(")
	is_add_owner_block(line)
}

has_or_remove_owner(lines) {
	line := lines[_]
	startswith(trim(line, " "), "OR(")
	is_remove_owner_block(line)
}

is_add_owner_block(line) {
	contains(line, "protoPayload.serviceData.policyDelta.bindingDeltas.action=\"ADD\"")
	contains(line, "protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\"")
}

is_remove_owner_block(line) {
	contains(line, "protoPayload.serviceData.policyDelta.bindingDeltas.action=\"REMOVE\"")
	contains(line, "protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\"")
}

at_least_one_log(log_resources){
	log_resources[_].value != []
}