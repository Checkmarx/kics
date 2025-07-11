package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	document := input.document[i]
	api = document.resource.aws_api_gateway_method[name]

	not common_lib.valid_key(api, "api_key_required")
	api.http_method != "OPTIONS"

	result := {
		"documentId": document.id,
		"resourceType": "aws_api_gateway_method",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("resource.aws_api_gateway_method[%s]", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_method", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("resource.aws_api_gateway_method[%s].api_key_required should be defined", [name]),
		"keyActualValue": sprintf("resource.aws_api_gateway_method[%s].api_key_required is undefined", [name]),
		"remediation": "api_key_required = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	document := input.document[i]
	api = document.resource.aws_api_gateway_method[name]

	api.api_key_required != true
	api.http_method != "OPTIONS"

	result := {
		"documentId": document.id,
		"resourceType": "aws_api_gateway_method",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("resource.aws_api_gateway_method[%s].api_key_required", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_method", name, "api_key_required"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("resource.aws_api_gateway_method[%s].api_key_required should be 'true'", [name]),
		"keyActualValue": sprintf("resource.aws_api_gateway_method[%s].api_key_required is 'false'", [name]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
