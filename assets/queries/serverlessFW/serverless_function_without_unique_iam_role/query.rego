package Cx

import data.generic.common as common_lib
import data.generic.serverlessfw as sfw_lib

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
		"keyExpectedValue": "'role' should be defined inside the function",
		"keyActualValue": "'role' is not defined",
		"searchLine": common_lib.build_search_line(["functions", fname], []),
	}
}

# IMPROVED VERSION: Reduces False Positives by considering legitimate role sharing scenarios
CxPolicy[result] {
	document := input.document[i]
	functions := document.functions
	is_object(functions)
	
	func1 := functions[name1]
	func2 := functions[name2]
	name1 != name2
	
	# Both functions have the same role
	func1.role == func2.role
	
	# Only flag if functions have different permission requirements
	has_different_sfw_permission_needs(func1, func2, document)

	result := {
		"documentId": input.document[i].id,
		"resourceType": sfw_lib.resourceTypeMapping("function", document.provider.name),
		"resourceName": name1,
		"searchKey": sprintf("functions.%s.role", [name1]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Functions '%s' and '%s' should have different IAM roles due to different permission requirements", [name1, name2]),
		"keyActualValue": sprintf("Functions '%s' and '%s' share the same IAM role", [name1, name2]),
		"searchLine": common_lib.build_search_line(["functions", name1, "role"], []),
	}
}

CxPolicy[result] {
	document := input.document[i]
	functions := document.functions
	is_array(functions)
	function := functions[k][fname]

	not common_lib.valid_key(function, "role")

	result := {
		"documentId": input.document[i].id,
		"resourceType": sfw_lib.resourceTypeMapping("function", document.provider.name),
		"resourceName": fname,
		"searchKey": sprintf("functions[%s].%s", [k,fname]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'role' should be defined inside the function",
		"keyActualValue": "'role' is not defined",
		"searchLine": common_lib.build_search_line(["functions",k ,fname], []),
	}
}

# Helper function: Determine if ServerlessFW functions have different permission needs
has_different_sfw_permission_needs(func1, func2, document) {
	# Different event sources indicate different permission requirements
	func1_events := get_sfw_event_types(func1)
	func2_events := get_sfw_event_types(func2)
	
	# If they have different event types, they likely need different permissions
	func1_events != func2_events
}

has_different_sfw_permission_needs(func1, func2, document) {
	# Different environment variables might indicate different permission needs
	func1_env := get_sfw_environment(func1, document)
	func2_env := get_sfw_environment(func2, document)
	
	# Check for AWS service-related environment variables
	has_aws_service_env(func1_env)
	has_aws_service_env(func2_env)
	func1_env != func2_env
}

# Helper function: Get event types from ServerlessFW function
get_sfw_event_types(function) = events {
	common_lib.valid_key(function, "events")
	events := {event_type | 
		event := function.events[_]
		event_keys := object.keys(event)
		event_type := event_keys[_]
	}
} else = events {
	# No events defined
	events := set()
}

# Helper function: Get environment variables from function
get_sfw_environment(function, document) = env {
	common_lib.valid_key(function, "environment")
	env := function.environment
} else = env {
	# Check provider-level environment
	common_lib.valid_key(document.provider, "environment")
	env := document.provider.environment
} else = env {
	env := {}
}

# Helper function: Check if environment has AWS service-related variables
has_aws_service_env(env) {
	aws_service_patterns := {"S3_BUCKET", "DYNAMODB_TABLE", "SQS_QUEUE", "SNS_TOPIC", "RDS_", "LAMBDA_"}
	env_key := object.keys(env)[_]
	contains(upper(env_key), aws_service_patterns[_])
}
