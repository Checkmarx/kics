package Cx

CxPolicy[result] {
	document := input.document[i]
	resource = document.resource.aws_apigatewayv2_stage[name]

	object.get(resource, "access_log_settings", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("aws_apigatewayv2_stage[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_apigatewayv2_stage[%s].access_log_settings is defined", [name]),
		"keyActualValue": sprintf("aws_apigatewayv2_stage[%s].access_log_settings is not defined", [name]),
	}
}
