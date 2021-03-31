package Cx

CxPolicy[result] {
	document := input.document[i]
	api = document.resource.aws_api_gateway_method[name]

	object.get(api, "api_key_required", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("resource.aws_api_gateway_method[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource.aws_api_gateway_method[%s].api_key_required is defined", [name]),
		"keyActualValue": sprintf("resource.aws_api_gateway_method[%s].api_key_required is undefined", [name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	api = document.resource.aws_api_gateway_method[name]

	api.api_key_required != true

	result := {
		"documentId": document.id,
		"searchKey": sprintf("resource.aws_api_gateway_method[%s].api_key_required", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_api_gateway_method[%s].api_key_required is 'true'", [name]),
		"keyActualValue": sprintf("resource.aws_api_gateway_method[%s].api_key_required is 'false'", [name]),
	}
}
