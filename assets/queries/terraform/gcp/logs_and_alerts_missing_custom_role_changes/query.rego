package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

resources := {"google_logging_metric", "google_monitoring_alert_policy"}

CxPolicy[result] {
	doc := input.document[i]
	log_or_alert := doc.resource[resources[m]][name]
	filter_data := get_filter(log_or_alert, resources[m], name)
	lines := split(filter_data.filter, "\n")

	target_methods := {"CreateRole", "UpdateRole", "UndeleteRole", "DeleteRole"}
	target_resource_type := "iam_role"
	keyActualValue := is_improper_filter(target_methods, target_resource_type, lines)

	result := {
		"documentId": doc.id,
		"resourceType": resources[m],
		"resourceName": tf_lib.get_resource_name(log_or_alert, name),
		"searchKey": sprintf("%s[%s].%s", [resources[m], name, filter_data.path]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s[%s].%s' should capture all custom role changes for resource type 'iam_role'", [resources[m], name, filter_data.path]),
		"keyActualValue": sprintf("'%s[%s].%s' %s", [resources[m], name, filter_data.path, keyActualValue]),
		"searchLine": common_lib.build_search_line(filter_data.searchArray, [])
	}
}

is_improper_filter(target_methods, target_resource_type, lines) = keyActualValue {
	not correct_resource_type(lines, target_resource_type)
	keyActualValue := "is applied to the wrong resource type"
} else = keyActualValue {
	not contains_method(target_methods, lines)
	keyActualValue := "does not capture all custom role changes for resource type 'iam_role'"
} else = keyActualValue {
	methods_decalared := {line |
	 line := lines[_]
	 not contains(line, "NOT")
	 not contains(line, "OR")
	 not contains(line, "!=")
	 contains(line, "protoPayload.methodName=")}

	count(methods_decalared) >= 2
	methods_decalared[x] != methods_decalared[y]		 # means filter declares method = x AND method = y

	keyActualValue := "declares an invalid filter, 'methodName' cannot be equal to multiple values simultaneously"
}

correct_resource_type(lines, target_resource_type) {
	contains(lines[_], sprintf("resource.type=\"%s\"",[target_resource_type]))
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

is_affirmative_or_double_negative(line) {
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
	contains(methods[x], "protoPayload.methodName:*") # restrictions allow all methods
}

get_filter(resource, type, name) = filter {
	type == "google_logging_metric"
	filter := {
		"filter" : resource.filter,
		"path" : "filter",
		"searchArray" : ["resource", type, name]
	}
} else = filter{
	filter := {
		"filter" : resource.conditions.condition_matched_log.filter,
		"path" : "conditions.condition_matched_log.filter",
		"searchArray" : ["resource", type, name]
	}
}
