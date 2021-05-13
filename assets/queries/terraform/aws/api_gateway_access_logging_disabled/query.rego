package Cx

CxPolicy[result] {
	api := input.document[i].resource.aws_api_gateway_stage[name]

	not api.access_log_settings

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_api_gateway_stage[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'access_log_settings' is defined",
		"keyActualValue": "'access_log_settings' is not defined",
	}
}

CxPolicy[result] {
	api := input.document[i].resource.aws_apigatewayv2_stage[name]

	not api.access_log_settings

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_apigatewayv2_stage[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'access_log_settings' is defined",
		"keyActualValue": "'access_log_settings' is not defined",
	}
}
