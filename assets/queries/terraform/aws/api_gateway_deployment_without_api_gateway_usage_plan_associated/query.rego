package Cx

CxPolicy[result] {
	document := input.document[i]
	deployment = document.resource.aws_api_gateway_deployment[name]

	not settings_are_equal(document.resource, deployment.rest_api_id, deployment.stage_name)

	result := {
		"documentId": document.id,
		"searchKey": sprintf("aws_api_gateway_deployment[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_api_gateway_deployment[%s] has a 'aws_api_gateway_usage_plan' resource associated. ", [name]),
		"keyActualValue": sprintf("aws_api_gateway_deployment[%s] doesn't have a 'aws_api_gateway_usage_plan' resource associated.", [name]),
	}
}

settings_are_equal(resource, rest_api_id, stage_name) {
	usage_plan := resource.aws_api_gateway_usage_plan[_]
	usage_plan.api_stages.api_id == rest_api_id
	usage_plan.api_stages.stage == stage_name
}
