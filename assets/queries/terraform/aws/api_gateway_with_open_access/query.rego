package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	document := input.document[i]
	resource = document.resource.aws_api_gateway_method[name]

	resource.authorization == "NONE"
	resource.http_method != "OPTIONS"

	result := {
		"documentId": document.id,
		"resourceType": "aws_api_gateway_method",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_api_gateway_method[%s].http_method", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_api_gateway_method.authorization is only 'NONE' if http_method is 'OPTIONS'",
		"keyActualValue": sprintf("aws_api_gateway_method[%s].authorization type is 'NONE' and http_method is not ''OPTIONS'", [name]),
	}
}
