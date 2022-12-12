package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_method_settings[name].settings
	resource.caching_enabled == true
	resource.cache_data_encrypted == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_method_settings",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_api_gateway_method_settings[{{%s}}].settings.cache_data_encrypted", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_method_settings", name,"settings","cache_data_encrypted" ], []),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_api_gateway_method_settings.settings.cache_data_encrypted should be set to true",
		"keyActualValue": "aws_api_gateway_method_settings.settings.cache_data_encrypted is set to false",
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_method_settings[name].settings
	resource.caching_enabled == true
	not common_lib.valid_key(resource, "cache_data_encrypted")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_method_settings",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("aws_api_gateway_method_settings[{{%s}}].settings", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_method_settings", name,"settings" ], []),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_api_gateway_method_settings.settings.cache_data_encrypted should be set to true",
		"keyActualValue": "aws_api_gateway_method_settings.settings.cache_data_encrypted is missing",
		"remediation": "cache_data_encrypted = true",
		"remediationType": "addition",
	}
}
