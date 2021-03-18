package Cx

CxPolicy[result] {
	document := input.document[i]
	resource = document.resource.aws_api_gateway_method[name]

	resource.authorization == "NONE"
	resource.http_method != "OPTIONS"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("aws_api_gateway_method[%s].authorization", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_api_gateway_method.authorization is only 'NONE' if http_method is 'OPTIONS'",
		"keyActualValue": sprintf("aws_api_gateway_method[%s].authorization type is 'NONE' and http_method is not ''OPTIONS'", [name]),
	}
}
