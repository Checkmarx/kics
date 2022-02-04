package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	restAPI := input.document[i].resource.aws_api_gateway_rest_api[name]

	not has_rest_api_associated(name)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_api_gateway_rest_api[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "API Gateway REST API is associated with an API Gateway Authorizer",
		"keyActualValue": "API Gateway REST API is not associated with an API Gateway Authorizer",
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_rest_api", name], []),
	}
}

has_rest_api_associated(apiName) {
	authorizer := input.document[_].resource.aws_api_gateway_authorizer[name]
	attributeSplit := split(authorizer.rest_api_id, ".")

	attributeSplit[0] == "${aws_api_gateway_rest_api"

	attributeSplit[1] == apiName
}
