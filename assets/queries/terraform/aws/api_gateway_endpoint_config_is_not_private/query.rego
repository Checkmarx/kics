package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_rest_api[name].endpoint_configuration
	resource.types[index] != "PRIVATE"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_rest_api",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_api_gateway_rest_api[%s].endpoint_configuration.types[%s]", [name,index]),
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_rest_api", name, "endpoint_configuration", "types", index], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'aws_api_gateway_rest_api.aws_api_gateway_rest_api.types' should be 'PRIVATE'.",
		"keyActualValue": "'aws_api_gateway_rest_api.aws_api_gateway_rest_api.types' is not 'PRIVATE'.",
		"remediation": json.marshal({
			"before": sprintf("%s",[resource.types[index]]),
			"after": "PRIVATE"
		}),
		"remediationType": "replacement",
	}
}
