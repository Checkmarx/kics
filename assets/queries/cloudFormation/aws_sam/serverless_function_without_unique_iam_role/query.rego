package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

# IMPROVED VERSION: Reduces False Positives by considering legitimate role sharing scenarios
CxPolicy[result] {
	resources := input.document[i].Resources
	resource := resources[k]
	resource.Type == "AWS::Serverless::Function"

	resources[j].Type == "AWS::Serverless::Function"
	resources[j].Properties.Role == resource.Properties.Role
	k != j
	
	# Only flag if functions have different permission requirements
	has_different_cf_permission_needs(resource, resources[j])

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, k),
		"searchKey": sprintf("Resources.%s.Properties.Role", [k]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resource.%s.Properties.Role is only assigned to the function in question", [k]),
		"keyActualValue": sprintf("Resource.%s.Properties.Role is assigned to another funtion", [k]),
	    "searchLine": common_lib.build_search_line(["Resources", k, "Properties", "Role"], []),
	}
}

# Helper function: Determine if CloudFormation functions have different permission needs
has_different_cf_permission_needs(func1, func2) {
	# Different event sources indicate different permission requirements
	func1_events := get_cf_event_types(func1)
	func2_events := get_cf_event_types(func2)
	
	# If they have different event types, they likely need different permissions
	func1_events != func2_events
}

has_different_cf_permission_needs(func1, func2) {
	# Different environment variables might indicate different permission needs
	func1_env := get_cf_environment(func1)
	func2_env := get_cf_environment(func2)
	
	# Check for AWS service-related environment variables
	has_aws_service_env(func1_env)
	has_aws_service_env(func2_env)
	func1_env != func2_env
}

# Helper function: Get event types from CloudFormation function
get_cf_event_types(function) = events {
	common_lib.valid_key(function.Properties, "Events")
	events := {event_type | 
		event := function.Properties.Events[_]
		event_type := event.Type
	}
} else = events {
	# No events defined
	events := set()
}

# Helper function: Get environment variables from CloudFormation function
get_cf_environment(function) = env {
	common_lib.valid_key(function.Properties, "Environment")
	common_lib.valid_key(function.Properties.Environment, "Variables")
	env := function.Properties.Environment.Variables
} else = env {
	env := {}
}

# Helper function: Check if environment has AWS service-related variables
has_aws_service_env(env) {
	aws_service_patterns := {"S3_BUCKET", "DYNAMODB_TABLE", "SQS_QUEUE", "SNS_TOPIC", "RDS_", "LAMBDA_"}
	env_key := object.keys(env)[_]
	contains(upper(env_key), aws_service_patterns[_])
}
