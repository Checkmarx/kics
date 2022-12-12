package Cx

import data.generic.common as commonLib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_rest_api[name]

	not resource.minimum_compression_size

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_rest_api",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_api_gateway_rest_api[%s]", [name]),
		"searchLine": commonLib.build_search_line(["resource", "aws_api_gateway_rest_api", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'minimum_compression_size' should be set and have a value greater than -1 and smaller than 10485760",
		"keyActualValue": "Attribute 'minimum_compression_size' is undefined",
		"remediation": "minimum_compression_size = 0",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_rest_api[name]

	not commonLib.between(resource.minimum_compression_size, 0, 10485759)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_rest_api",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_api_gateway_rest_api[%s].minimum_compression_size", [name]),
		"searchLine": commonLib.build_search_line(["resource", "aws_api_gateway_rest_api", name, "minimum_compression_size"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'minimum_compression_size' should be greater than -1 and smaller than 10485760",
		"keyActualValue": sprintf("Attribute 'minimum_compression_size' is %d", [resource.minimum_compression_size]),
		"remediation": json.marshal({
			"before": sprintf("%d", [resource.minimum_compression_size]),
			"after": "0"
		}),
		"remediationType": "replacement",
	}
}
