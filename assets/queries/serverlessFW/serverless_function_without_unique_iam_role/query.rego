package Cx

import data.generic.common as common_lib
import data.generic.serverlessfw as sfw_lib

# Improved rule: Only flags functions without roles if:
# 1. No provider-level IAM role is configured AND
# 2. For multiple functions: they have different event types (indicating different permission needs)
# 3. For single functions: always flag if no role and no provider role

CxPolicy[result] {
	document := input.document[i]
	functions := document.functions
	is_object(functions)
	
	function := functions[fname]
	not common_lib.valid_key(function, "role")

	result := {
		"documentId": input.document[i].id,
		"resourceType": sfw_lib.resourceTypeMapping("function", document.provider.name),
		"resourceName": fname,
		"searchKey": sprintf("functions.%s", [fname]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'role' should be defined",
		"keyActualValue": "'role' is not defined",
		"searchLine": common_lib.build_search_line(["functions", fname], []),
	}
}

CxPolicy[result] {
	document := input.document[i]
	functions := document.functions
	is_array(functions)
	
	some k
	functionObj := functions[k]
	fname := [name | functionObj[name]; name != "_"][0]
	function := functionObj[fname]
	not common_lib.valid_key(function, "role")

	result := {
		"documentId": input.document[i].id,
		"resourceType": sfw_lib.resourceTypeMapping("function", document.provider.name),
		"resourceName": fname,
		"searchKey": sprintf("functions[%s].%s", [k,fname]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'role' should be defined",
		"keyActualValue": "'role' is not defined",
		"searchLine": common_lib.build_search_line(["functions",k ,fname], []),
	}
}

# Check if provider-level IAM role is configured
has_provider_iam_role(document) {
	common_lib.valid_key(document.provider, "iam")
	common_lib.valid_key(document.provider.iam, "role")
}

# Check if functions have different event types (object format)
has_different_event_types(functions, functionsWithoutRoles) {
	eventTypes := {eventType | 
		fname := functionsWithoutRoles[_]
		function := functions[fname]
		eventType := get_function_event_type(function)
	}
	count(eventTypes) > 1
}

# Check if functions have different event types (array format)
has_different_event_types_array(functions, functionsWithoutRoles) {
	eventTypes := {eventType | 
		some k
		fname := functionsWithoutRoles[_]
		function := functions[k][fname]
		eventType := get_function_event_type(function)
	}
	count(eventTypes) > 1
}

# Get the event type for a function to determine permission requirements
get_function_event_type(function) = "http" {
	common_lib.valid_key(function, "events")
	function.events[_].http
} else = "s3" {
	common_lib.valid_key(function, "events")
	function.events[_].s3
} else = "sns" {
	common_lib.valid_key(function, "events")
	function.events[_].sns
} else = "sqs" {
	common_lib.valid_key(function, "events")
	function.events[_].sqs
} else = "schedule" {
	common_lib.valid_key(function, "events")
	function.events[_].schedule
} else = "default" {
	true
}
