package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

# Improved rule: Only flags role sharing when functions have different event types
# indicating different permission needs

CxPolicy[result] {
	resources := input.document[i].Resources
	resource := resources[k]
	resource.Type == "AWS::Serverless::Function"

	resources[j].Type == "AWS::Serverless::Function"
	resources[j].Properties.Role == resource.Properties.Role
	k != j
	
	# Only flag if functions have different event types or environment variables
	# indicating different permission requirements
	functions_need_different_permissions(resource, resources[j])

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, k),
		"searchKey": sprintf("Resources.%s.Properties.Role", [k]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resource.%s.Properties.Role should be unique when functions have different permission requirements", [k]),
		"keyActualValue": sprintf("Resource.%s.Properties.Role is shared with another function that has different permission requirements", [k]),
	    "searchLine": common_lib.build_search_line(["Resources", k, "Properties", "Role"], []),
	}
}

# Check if functions need different permissions based on event sources and environment variables
functions_need_different_permissions(func1, func2) {
	event_type_1 := get_function_event_type(func1)
	event_type_2 := get_function_event_type(func2)
	event_type_1 != event_type_2
} else {
	# Check environment variables for AWS service indicators
	has_different_aws_service_env_vars(func1, func2)
}

# Get the primary event type for a function
get_function_event_type(function) = "api" {
	common_lib.valid_key(function.Properties, "Events")
	function.Properties.Events[_].Type == "Api"
} else = "s3" {
	common_lib.valid_key(function.Properties, "Events")
	function.Properties.Events[_].Type == "S3"
} else = "sns" {
	common_lib.valid_key(function.Properties, "Events")
	function.Properties.Events[_].Type == "SNS"
} else = "sqs" {
	common_lib.valid_key(function.Properties, "Events")
	function.Properties.Events[_].Type == "SQS"
} else = "schedule" {
	common_lib.valid_key(function.Properties, "Events")
	function.Properties.Events[_].Type == "Schedule"
} else = "dynamodb" {
	common_lib.valid_key(function.Properties, "Events")
	function.Properties.Events[_].Type == "DynamoDB"
} else = "default" {
	true
}

# Check if functions have different AWS service-related environment variables
has_different_aws_service_env_vars(func1, func2) {
	env1 := get_aws_service_env_vars(func1)
	env2 := get_aws_service_env_vars(func2)
	count(env1 & env2) != count(env1 | env2)  # Different sets of AWS services
}

# Extract AWS service indicators from environment variables
get_aws_service_env_vars(function) = services {
	common_lib.valid_key(function.Properties, "Environment")
	common_lib.valid_key(function.Properties.Environment, "Variables")
	vars := function.Properties.Environment.Variables
	services := {service | 
		var_name := vars[_]
		service := extract_aws_service_from_var(var_name)
		service != ""
	}
} else = set() {
	true
}

# Extract AWS service name from environment variable names
extract_aws_service_from_var(var_name) = "dynamodb" {
	contains(lower(var_name), "dynamodb")
} else = "s3" {
	contains(lower(var_name), "s3")
} else = "sns" {
	contains(lower(var_name), "sns")
} else = "sqs" {
	contains(lower(var_name), "sqs")
} else = "rds" {
	contains(lower(var_name), "rds")
} else = "" {
	true
}
