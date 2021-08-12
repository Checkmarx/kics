package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_method_settings[name].settings
	resource.metrics_enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_api_gateway_method_settings[%s].settings.metrics_enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_api_gateway_method_settings[%s].settings.metrics_enabled is true", [name]),
		"keyActualValue": sprintf("aws_api_gateway_method_settings[%s].settings.metrics_enabled is false", [name]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_method_settings[name].settings
	not common_lib.valid_key(resource, "metrics_enabled")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_api_gateway_method_settings[%s].settings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_api_gateway_method_settings[%s].settings.metrics_enabled is defined and not null", [name]),
		"keyActualValue": sprintf("aws_api_gateway_method_settings[%s].settings.metrics_enabled is undefined or null", [name]),
	}
}
