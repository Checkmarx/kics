package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	document := input.document[i]
	deployment = document.resource.aws_api_gateway_deployment[name]

	count({x | resource := input.document[_].resource[x]; x == "aws_api_gateway_stage"}) == 0

	result := {
		"documentId": document.id,
		"resourceType": "aws_api_gateway_deployment",
		"resourceName": tf_lib.get_resource_name(deployment, name),
		"searchKey": sprintf("aws_api_gateway_deployment[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_api_gateway_deployment[%s] has a 'aws_api_gateway_stage' resource associated", [name]),
		"keyActualValue": sprintf("aws_api_gateway_deployment[%s] doesn't have a 'aws_api_gateway_stage' resource associated", [name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	deployment = document.resource.aws_api_gateway_deployment[name]

	count({x | resource := input.document[_].resource[x]; x == "aws_api_gateway_stage"}) != 0

	not settings_are_equal(name)

	result := {
		"documentId": document.id,
		"resourceType": "aws_api_gateway_deployment",
		"resourceName": tf_lib.get_resource_name(deployment, name),
		"searchKey": sprintf("aws_api_gateway_deployment[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_api_gateway_deployment[%s] has a 'aws_api_gateway_stage' resource associated with 'access_log_settings' set", [name]),
		"keyActualValue": sprintf("aws_api_gateway_deployment[%s] doesn't have a 'aws_api_gateway_stage' resource associated with 'access_log_settings' set", [name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	deployment = document.resource.aws_api_gateway_deployment[name]

	count({x | resource := input.document[_].resource[x]; x == "aws_api_gateway_stage"}) != 0

	settings_are_equal(name)

	not common_lib.valid_key(deployment, "stage_description")

	result := {
		"documentId": document.id,
		"resourceType": "aws_api_gateway_deployment",
		"resourceName": tf_lib.get_resource_name(deployment, name),
		"searchKey": sprintf("aws_api_gateway_deployment[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_api_gateway_deployment[%s].stage_description should be set", [name]),
		"keyActualValue": sprintf("aws_api_gateway_deployment[%s].stage_description is undefined", [name]),
	}
}

settings_are_equal(name) {
	count({x |
		stage := input.document[_].resource[x]
		x == "aws_api_gateway_stage"
		has_reference(stage[y].deployment_id, name)
		has_access_log_settings(stage[y])
	}) != 0
}

has_reference(deploymentId, name) {
	expected := sprintf("aws_api_gateway_deployment.%s.id", [name])
	contains(deploymentId, expected) == true
}

has_access_log_settings(resource) {
	common_lib.valid_key(resource, "access_log_settings")
}
