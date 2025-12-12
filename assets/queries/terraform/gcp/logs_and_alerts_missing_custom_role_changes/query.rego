package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

types := {"google_logging_metric", "google_monitoring_alert_policy"}
target_methods := {"google.iam.admin.v1.CreateRole", "google.iam.admin.v1.UpdateRole", "google.iam.admin.v1.UndeleteRole", "google.iam.admin.v1.DeleteRole"}

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

	results := [res | filters_data := logs_filters_data[i]
		keyActualValue := single_match(filters_data)
		keyActualValue != null
		res := {
			"documentId": input.document[filters_data.doc_index].id,
			"resourceType": "google_logging_metric",
			"resourceName": tf_lib.get_resource_name(filters_data.resource, filters_data.name),
			"searchKey": sprintf("google_logging_metric[%s].%s", [filters_data.name, filters_data.path]),
			"issueType":  "IncorrectValue",
			"keyExpectedValue": "At least one 'google_logging_metric' resource should capture all custom role changes",
			"keyActualValue": sprintf("'google_logging_metric[%s].%s' %s", [filters_data.name, filters_data.path, keyActualValue]),
			"searchLine": common_lib.build_search_line(filters_data.searchArray, [])
		}]
	results != []
} else = results {
	log_resources[_].value != []
	alert_resources[_].value != []
	logs_filters_data := [log | log := get_data(log_resources[_].value[name_log], "google_logging_metric", name_log, log_resources[_].document_index)]

	valid_logs_names := [logs_filters_data[i2].name |
		lines := process_filter(logs_filters_data[i2].filter)
		is_improper_filter(target_methods, lines) == null
	]

	alerts_filters_data := [alert | alert := get_data(alert_resources[_].value[name_al], "google_monitoring_alert_policy", name_al, alert_resources[_].document_index)]

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

	keyActualValue := is_improper_filter(target_methods, lines)
}

process_filter(raw_filter) = filter {
	filter := split(regex.replace(regex.replace(regex.replace(raw_filter, "\\n", ""), "\\s*AND\\s*", "\nAND"), "\\s*OR\\s*", "\nOR"), "\n")
	# first all \n are removed then \n are added on each AND or OR declaration so that each line starts with its corresponding logical operator
	# the resulting string is split so we can have an array of operations
}

has_regex_match_or_reference(alerts_filters_data, valid_logs_names) = true {
	lines := process_filter(alerts_filters_data[i].filter)
	is_improper_filter(target_methods, lines) == null
	alerts_filters_data[i].resource.notification_channels
} else = true {
	alerts_filters_data[i].allows_ref == true
	alerts_filters_data[i].resource.notification_channels
	contains(alerts_filters_data[i].filter, sprintf("logging.googleapis.com/user/%s",[valid_logs_names[_]]))
} else = index {
	lines := process_filter(alerts_filters_data[index].filter)
	is_improper_filter(target_methods, lines) == null
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

is_improper_filter(target_methods, lines) = keyActualValue {
	not correct_resource_type(lines)
	keyActualValue := "is applied to the wrong resource type"
} else = keyActualValue {
	not contains_method(target_methods, lines)
	keyActualValue := "does not capture all custom role changes for resource type 'iam_role'"
} else = keyActualValue {
	methods_decalared := {line |
	 line := lines[_]
	 is_affirmative_or_double_negative(line)
	 not contains(line, "OR")
	 regex.match("(?i)protoPayload\\.methodName\\s*=\\s*", line)}

	count(methods_decalared) >= 2
	methods_decalared[x] != methods_decalared[y]		 # means filter declares method = x AND method = y

	keyActualValue := "declares an invalid filter, 'methodName' cannot be equal to multiple values simultaneously"
} else = keyActualValue {
	invalid_declarations := {line |										# we know these will not include the targets
						line := lines[_]
						contains(line, "AND")
						is_affirmative_or_double_negative(line)
						not contains_target_method(line)}
	count(invalid_declarations) != 0
	keyActualValue := sprintf("declares an invalid filter, the filter is excessively restrictive with %d extra restrictions over the expected ammount", [count(invalid_declarations)])
} else = null

correct_resource_type(lines) {
	regex.match("(?i)resource\\.type\\s*=\\s*(\\(((\\s*OR\\s*)?\".+\"(\\s*OR\\s*)?)*)?\"iam_role\"", concat("", lines))
}

contains_target_method(line) {
	contains(line, target_methods[_])
} else {
	regex.match("(?i)protoPayload\\.methodName\\s*=\\s*\\*", line)
}

at_least_one_log(log_resources) {
	log_resources[_].value != []
}

contains_method(target_methods, lines) {
	not_statements := {method |
	 method := target_methods[_]
	 line := lines[_]
	 contains(line, "NOT")
	 not contains(line, "!=")
	 contains(line, method)}

	count(not_statements) == 0		# must not negate any necessary method

	found_methods := {method |
	 method := target_methods[_]
	 line := lines[_]
	 is_affirmative_or_double_negative(line)
	 contains(line, method)}

	found_methods == target_methods	 # must have all necessary methods ( "=" or "NOT !=")
} else {
	methods := {line |
	 line := lines[_]
	 contains(line, "protoPayload.methodName")}

	all_methods_allowed(methods)
}

is_affirmative_or_double_negative(line) {	# assumes "NOT NOT" is invalid
	 not contains(line, "NOT")
	 not contains(line, "!=")
} else {
	 contains(line, "NOT")
	 contains(line, "!=")
}

all_methods_allowed(methods) {
	count(methods) == 0					# no method restrictions
} else {
	count(methods) == 1
	regex.match("(?i)protoPayload\\.methodName\\s*=\\s*\\*", methods[x])	# restrictions allow all methods
}
