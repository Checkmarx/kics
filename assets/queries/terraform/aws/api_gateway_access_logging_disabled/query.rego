package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	api := input.document[i].resource.aws_apigatewayv2_stage[name]

	searchKeyValid := validNonEmptyKey(api, "default_route_settings")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_apigatewayv2_stage",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("aws_apigatewayv2_stage[%s]%s", [name, searchKeyValid]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_apigatewayv2_stage[%s].default_route_settings should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_apigatewayv2_stage[%s].default_route_settings isn't defined or is null", [name]),
	}
}

CxPolicy[result] {
	api := input.document[i].resource.aws_apigatewayv2_stage[name]

	defaultRouteSettings := api.default_route_settings
	searchKeyValid := validNonEmptyKey(defaultRouteSettings, "logging_level")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_apigatewayv2_stage",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("aws_apigatewayv2_stage[%s].default_route_settings%s", [name, searchKeyValid]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_apigatewayv2_stage[%s].default_route_settings.logging_level should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_apigatewayv2_stage[%s].default_route_settings.logging_level isn't defined or is null", [name]),
	}
}

CxPolicy[result] {
	api := input.document[i].resource.aws_apigatewayv2_stage[name]

	defaultRouteSettings := api.default_route_settings
	loggingLevel := defaultRouteSettings.logging_level
	loggingLevel == "OFF"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_apigatewayv2_stage",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("aws_apigatewayv2_stage[%s].default_route_settings.logging_level", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_apigatewayv2_stage[%s].default_route_settings.logging_level should not be set to OFF", [name]),
		"keyActualValue": "aws_apigatewayv2_stage[%s].default_route_settings.logging_level is set to OFF",
	}
}

CxPolicy[result] {
	api := input.document[i].resource.aws_api_gateway_stage[name]

	searchKeyValid := validNonEmptyKey(api, "settings")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_stage",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("aws_api_gateway_stage[%s]%s", [name, searchKeyValid]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_api_gateway_stage[%s].settings should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_api_gateway_stage[%s].settings isn't defined or is null", [name]),
	}
}

CxPolicy[result] {
	api := input.document[i].resource.aws_api_gateway_stage[name]

	settings := api.settings
	searchKeyValid := validNonEmptyKey(settings, "logging_level")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_stage",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("aws_api_gateway_stage[%s].settings%s", [name, searchKeyValid]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_api_gateway_stage[%s].settings.logging_level should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_api_gateway_stage[%s].settings.logging_level isn't defined or is null", [name]),
	}
}

CxPolicy[result] {
	api := input.document[i].resource.aws_api_gateway_stage[name]

	settings := api.settings
	loggingLevel := settings.logging_level
	loggingLevel == "OFF"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_stage",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("aws_api_gateway_stage[%s].settings.logging_level", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_api_gateway_stage[%s].settings.logging_level should not be set to OFF", [name]),
		"keyActualValue": "aws_api_gateway_stage[%s].settings.logging_level is set to OFF",
	}
}

CxPolicy[result] {
	api := input.document[i].resource.aws_api_gateway_stage[name]

	not api.access_log_settings

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_stage",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("aws_api_gateway_stage[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'access_log_settings' should be defined",
		"keyActualValue": "'access_log_settings' is not defined",
	}
}

CxPolicy[result] {
	api := input.document[i].resource.aws_apigatewayv2_stage[name]

	not api.access_log_settings

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_apigatewayv2_stage",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("aws_apigatewayv2_stage[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'access_log_settings' should be defined",
		"keyActualValue": "'access_log_settings' is not defined",
	}
}

validNonEmptyKey(field, key) = output {
	not common_lib.valid_key(field, key)
	output = ""
} else = output {
	keyObj := field[key]
	is_object(keyObj)
	count(keyObj) == 0
	output := concat(".", ["", key])
} else = output {
	keyObj := field[key]
	keyObj == ""
	output := concat(".", ["", key])
}
