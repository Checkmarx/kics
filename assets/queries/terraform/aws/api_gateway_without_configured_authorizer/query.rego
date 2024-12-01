package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	restAPI := document.resource.aws_api_gateway_rest_api[name]

	not has_rest_api_associated(name)

	result := {
		"documentId": document.id,
		"resourceType": "aws_api_gateway_rest_api",
		"resourceName": tf_lib.get_resource_name(restAPI, name),
		"searchKey": sprintf("aws_api_gateway_rest_api[%s]", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "API Gateway REST API should be associated with an API Gateway Authorizer",
		"keyActualValue": "API Gateway REST API is not associated with an API Gateway Authorizer",
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_rest_api", name], []),
	}
}

has_rest_api_associated(apiName) {
	some doc in input.document
	authorizer := doc.resource.aws_api_gateway_authorizer[name]
	attributeSplit := split(authorizer.rest_api_id, ".")

	attributeSplit[0] == "${aws_api_gateway_rest_api"

	attributeSplit[1] == apiName
}
