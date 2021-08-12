package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_stage[name]
	resource.xray_tracing_enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_api_gateway_stage[%s].xray_tracing_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'aws_api_gateway_stage[%s].xray_tracing_enabled' is true", [name]),
		"keyActualValue": sprintf("'aws_api_gateway_stage[%s].xray_tracing_enabled' is false", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_stage[name]
	not common_lib.valid_key(resource, "xray_tracing_enabled")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_api_gateway_stage[%s].xray_tracing_enabled", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'aws_api_gateway_stage[%s].xray_tracing_enabled' is set", [name]),
		"keyActualValue": sprintf("'aws_api_gateway_stage[%s].xray_tracing_enabled' is undefined", [name]),
	}
}
