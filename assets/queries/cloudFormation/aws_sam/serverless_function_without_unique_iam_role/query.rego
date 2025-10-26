package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

# AWS Serverless Function should not share IAM Role
CxPolicy[result] {
	resources := input.document[i].Resources
	resource := resources[k]
	resource.Type == "AWS::Serverless::Function"

	resources[j].Type == "AWS::Serverless::Function"
	resources[j].Properties.Role == resource.Properties.Role
	k != j
	
	# Don't flag if functions have identical permission indicators (same events + same env)
	not has_identical_permission_indicators(resource, resources[j])

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

# Check if functions have identical permission indicators
has_identical_permission_indicators(func1, func2) {
	# Same event types AND no different AWS service types in env = can share role
	func1_events := get_cf_event_types(func1)
	func2_events := get_cf_event_types(func2)
	func1_events == func2_events
	count(func1_events) > 0  # Must have events to compare
	
	# Check if they use different AWS services
	not uses_different_aws_services(func1, func2)
}

# Check if functions use different AWS service types
uses_different_aws_services(func1, func2) {
	func1_env := get_cf_environment(func1)
	func2_env := get_cf_environment(func2)
	
	func1_services := get_aws_service_types_from_env(func1_env)
	func2_services := get_aws_service_types_from_env(func2_env)
	
	count(func1_services) > 0
	count(func2_services) > 0
	func1_services != func2_services
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
	# Different AWS service TYPES in environment variables indicate different permission needs
	func1_env := get_cf_environment(func1)
	func2_env := get_cf_environment(func2)
	
	# Get AWS service types from environment variables
	func1_services := get_aws_service_types_from_env(func1_env)
	func2_services := get_aws_service_types_from_env(func2_env)
	
	# Only flag if they use different AWS service types (not just different values)
	count(func1_services) > 0
	count(func2_services) > 0
	func1_services != func2_services
}

# Helper function: Get AWS service types from environment variables
get_aws_service_types_from_env(env) = services {
	aws_service_patterns := {
		"S3": "S3_BUCKET",
		"DYNAMODB": "DYNAMODB_TABLE",
		"SQS": "SQS_QUEUE",
		"SNS": "SNS_TOPIC",
		"RDS": "RDS_",
		"LAMBDA": "LAMBDA_"
	}
	services := {service_type |
		env_key := object.keys(env)[_]
		pattern := aws_service_patterns[service_type]
		contains(upper(env_key), pattern)
	}
} else = services {
	services := set()
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
