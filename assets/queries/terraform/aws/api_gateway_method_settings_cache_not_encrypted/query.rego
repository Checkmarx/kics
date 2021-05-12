package Cx

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_method_settings[name].settings
	resource.caching_enabled == true
	resource.cache_data_encrypted == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_api_gateway_method_settings[{{%s}}].settings.cache_data_encrypted", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "aws_api_gateway_method_settings.settings.cache_data_encrypted is set to true",
		"keyActualValue": "aws_api_gateway_method_settings.settings.cache_data_encrypted is set to false",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.aws_api_gateway_method_settings[name].settings
	resource.caching_enabled == true
	object.get(resource, "cache_data_encrypted", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("aws_api_gateway_method_settings[{{%s}}].settings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "aws_api_gateway_method_settings.settings.cache_data_encrypted is set to true",
		"keyActualValue": "aws_api_gateway_method_settings.settings.cache_data_encrypted is missing",
	}
}
