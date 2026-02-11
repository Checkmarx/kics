package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

types := {"google_logging_metric", "google_monitoring_alert_policy"}

service_name_pattern := "protopayload\\.servicename=\"cloudresourcemanager\\.googleapis\\.com\""
ownership_pattern_1 := "\\(projectownershiporprojectownerinvitee\\)"
ownership_pattern_2 := "\\(projectownerinviteeorprojectownership\\)"
binding_action_remove := "protopayload\\.servicedata\\.policydelta\\.bindingdeltas\\.action=\"remove\""
binding_action_add := "protopayload\\.servicedata\\.policydelta\\.bindingdeltas\\.action=\"add\""
binding_role_owner := "protopayload\\.servicedata\\.policydelta\\.bindingdeltas\\.role=\"roles/owner\""

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

	results := [res | 
		filters_data := logs_filters_data[i]
		not single_match(filters_data.filter)
		res := {
			"documentId": input.document[logs_filters_data[i].doc_index].id,
			"resourceType": "google_logging_metric",
			"resourceName": tf_lib.get_resource_name(logs_filters_data[i].resource, logs_filters_data[i].name),
			"searchKey": sprintf("google_logging_metric[%s].%s", [logs_filters_data[i].name, logs_filters_data[i].path]),
			"issueType":  "IncorrectValue",
			"keyExpectedValue": "At least one 'google_logging_metric' resource should capture project ownership assignment and changes",
			"keyActualValue": "No 'google_logging_metric' resource captures project ownership assignment and changes",
			"searchLine": common_lib.build_search_line(logs_filters_data[i].searchArray, [])
		}
	]
	count(results) == count(logs_filters_data)
} else = results {
	# there is at leat one of google_logging_metric and google_monitoring_alert_policies
	log_resources[_].value != []
	alert_resources[_].value != []
	logs_filters_data := [log | log := get_data(log_resources[_].value[log_name], "google_logging_metric", log_name, log_resources[_].document_index)]

	valid_logs_names := [logs_filters_data[i2].name |
  		single_match(logs_filters_data[i2].filter)
	]

	alerts_filters_data := [alert | alert := get_data(alert_resources[_].value[name_al], "google_monitoring_alert_policy", name_al, log_resources[_].document_index)]

	value := has_regex_match_or_reference(alerts_filters_data, valid_logs_names)

	results := get_results(alerts_filters_data, value)
} else = results {
	# very similar to the scenario above but, this time we check that there isn't a single 
	# google_logging_metric resource in the project.
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

single_match(filter) {
	processed_filter := lower(regex.replace(filter, "\\s+", ""))
	is_valid_filter(processed_filter)
}

is_valid_filter(filter) {
	service_name_valid(filter) # checks if serviceName is defined to "cloudresourcemanager.googleapis.com"
	ownership_valid(filter) # checks if (ProjectOwnership OR projectOwnerInvitee) is present
	remove_owner_valid(filter) # checks if (action="REMOVE" AND role="roles/owner") is present
	add_owner_valid(filter) # checks if (action="ADD" AND role="roles/owner") is present
}

has_regex_match_or_reference(alerts_filters_data, valid_logs_names) = true {
	single_match(alerts_filters_data[i].filter)
	alerts_filters_data[i].resource.notification_channels
} else = true {
	alerts_filters_data[i].allows_ref == true
	alerts_filters_data[i].resource.notification_channels
	contains(alerts_filters_data[i].filter, sprintf("logging.googleapis.com/user/%s",[valid_logs_names[_]]))
} else = index { # correct filter but missing notification_channels
	single_match(alerts_filters_data[index].filter)
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

at_least_one_log(log_resources){
	log_resources[_].value != []
}


service_name_valid(filter) { # checks if serviceName is defined to "cloudresourcemanager.googleapis.com"
	regex.match(service_name_pattern, filter)
	not regex.match(concat("", ["not", service_name_pattern]), filter)
}

ownership_valid(filter) { # (ProjectOwnership OR projectOwnerInvitee)
	regex.match(ownership_pattern_1, filter)
	not regex.match(concat("", ["not", ownership_pattern_1]), filter)
} else { # (projectOwnerInvitee OR ProjectOwnership)
	regex.match(ownership_pattern_2, filter)
	not regex.match(concat("", ["not", ownership_pattern_2]), filter)
}

remove_owner_valid(filter) { # action="REMOVE" AND role="roles/owner"
	pattern := concat("", ["\\(", binding_action_remove, "and", binding_role_owner, "\\)"])
    regex.match(pattern, filter)
    not regex.match(concat("", ["not", pattern]), filter)
} else { # role="roles/owner" AND action="REMOVE"
	pattern := concat("", ["\\(", binding_role_owner, "and", binding_action_remove, "\\)"])
    regex.match(pattern, filter)
    not regex.match(concat("", ["not", pattern]), filter)
}

add_owner_valid(filter) { # action="ADD" AND role="roles/owner"
	pattern := concat("", ["\\(", binding_action_add, "and", binding_role_owner, "\\)"])
    regex.match(pattern, filter)
    not regex.match(concat("", ["not", pattern]), filter)
} else { # role="roles/owner" AND action="ADD"
	pattern := concat("", ["\\(", binding_role_owner, "and", binding_action_add, "\\)"])
    regex.match(pattern, filter)
    not regex.match(concat("", ["not", pattern]), filter)
}