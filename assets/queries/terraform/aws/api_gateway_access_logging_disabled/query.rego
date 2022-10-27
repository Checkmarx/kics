package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	api := input.document[i].resource.aws_api_gateway_stage[name]

	not api.access_log_settings

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_stage",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("aws_api_gateway_stage[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'access_log_settings' should be defined",
		"keyActualValue": "'access_log_settings' is not defined",
	}
}

CxPolicy[result] {
	api := input.document[i].resource.aws_apigatewayv2_stage[name]

	not api.access_log_settings

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_apigatewayv2_stage",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("aws_apigatewayv2_stage[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'access_log_settings' should be defined",
		"keyActualValue": "'access_log_settings' is not defined",
	}
}
