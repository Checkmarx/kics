package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	document := input.document[i]
	stage = document.resource.aws_api_gateway_stage[name]

	not settings_are_equal(document.resource, stage.rest_api_id, stage.stage_name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_stage",
		"resourceName": tf_lib.get_resource_name(stage, name),
		"searchKey": sprintf("aws_api_gateway_stage[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_api_gateway_stage[%s] has a 'aws_api_gateway_usage_plan' resource associated. ", [name]),
		"keyActualValue": sprintf("aws_api_gateway_stage[%s] doesn't have a 'aws_api_gateway_usage_plan' resource associated.", [name]),
	}
}

settings_are_equal(resource, rest_api_id, stage_name) {
	usage_plan := resource.aws_api_gateway_usage_plan[_]
	usage_plan.api_stages.api_id == rest_api_id
	usage_plan.api_stages.stage == stage_name
}
