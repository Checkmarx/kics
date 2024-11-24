package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_api_gateway_stage[name]
	resource.xray_tracing_enabled == false

	result := {
		"documentId": document.id,
		"resourceType": "aws_api_gateway_stage",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_api_gateway_stage[%s].xray_tracing_enabled", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_stage", name, "xray_tracing_enabled"], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_api_gateway_stage[%s].xray_tracing_enabled' should be true", [name]),
		"keyActualValue": sprintf("'aws_api_gateway_stage[%s].xray_tracing_enabled' is false", [name]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true",
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource.aws_api_gateway_stage[name]
	not common_lib.valid_key(resource, "xray_tracing_enabled")

	result := {
		"documentId": document.id,
		"resourceType": "aws_api_gateway_stage",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_api_gateway_stage[%s].xray_tracing_enabled", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_stage", name], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'aws_api_gateway_stage[%s].xray_tracing_enabled' should be set", [name]),
		"keyActualValue": sprintf("'aws_api_gateway_stage[%s].xray_tracing_enabled' is undefined", [name]),
		"remediation": "xray_tracing_enabled = true",
		"remediationType": "addition",
	}
}
