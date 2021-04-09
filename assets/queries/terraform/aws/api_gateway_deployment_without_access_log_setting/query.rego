package Cx

CxPolicy[result] {
	document := input.document[i]
	deployment = document.resource.aws_api_gateway_deployment[name]

	count({x | resource := input.document[_].resource[x]; x == "aws_api_gateway_stage"}) == 0

	result := {
		"documentId": document.id,
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

	object.get(deployment, "stage_description", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("aws_api_gateway_deployment[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_api_gateway_deployment[%s].stage_description is set", [name]),
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
	object.get(resource, "access_log_settings", "undefined") != "undefined"
}
