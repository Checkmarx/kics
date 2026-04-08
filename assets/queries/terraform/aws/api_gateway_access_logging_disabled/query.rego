package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	api := input.document[i].resource.aws_apigatewayv2_stage[name]

	not common_lib.valid_key(api, "default_route_settings")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_apigatewayv2_stage",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("aws_apigatewayv2_stage[%s]", [name]),
		"searchValue": "default_route_settings",
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_apigatewayv2_stage[%s].default_route_settings should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_apigatewayv2_stage[%s].default_route_settings isn't defined or is null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_apigatewayv2_stage", name], []),
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
		"searchValue": "access_log_settings",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'access_log_settings' should be defined",
		"keyActualValue": "'access_log_settings' is not defined",
		"searchLine": common_lib.build_search_line(["resource", "aws_apigatewayv2_stage", name], []),
	}
}

CxPolicy[result] {
	api := input.document[i].resource.aws_apigatewayv2_stage[name]

	defaultRouteSettings := api.default_route_settings
	not common_lib.valid_key(defaultRouteSettings, "logging_level")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_apigatewayv2_stage",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("aws_apigatewayv2_stage[%s].default_route_settings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_apigatewayv2_stage[%s].default_route_settings.logging_level should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_apigatewayv2_stage[%s].default_route_settings.logging_level isn't defined or is null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_apigatewayv2_stage", name], ["default_route_settings"]),
	}
}

CxPolicy[result] {
	api := input.document[i].resource.aws_apigatewayv2_stage[name]

	defaultRouteSettings := api.default_route_settings
	loggingLevel := defaultRouteSettings.logging_level
	loggingLevel == ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_apigatewayv2_stage",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("aws_apigatewayv2_stage[%s].default_route_settings.logging_level", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_apigatewayv2_stage[%s].default_route_settings.logging_level should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_apigatewayv2_stage[%s].default_route_settings.logging_level isn't defined or is null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_apigatewayv2_stage", name], ["default_route_settings", "logging_level"]),
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
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_apigatewayv2_stage[%s].default_route_settings.logging_level should not be set to OFF", [name]),
		"keyActualValue": sprintf("aws_apigatewayv2_stage[%s].default_route_settings.logging_level is set to OFF", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_apigatewayv2_stage", name], ["default_route_settings", "logging_level"]),
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
		"searchValue": "access_log_settings",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'access_log_settings' should be defined",
		"keyActualValue": "'access_log_settings' is not defined",
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_stage", name], []),
	}
}

CxPolicy[result] {
	api := input.document[i].resource.aws_api_gateway_stage[name]

	x := [ methodSettings |
		methodSettings := input.document[i].resource.aws_api_gateway_method_settings[_];
		split(methodSettings.stage_name,".")[1] == name
	]

	count(x) == 0
	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_stage",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("aws_api_gateway_stage[%s]", [name]),
		"searchValue": "aws_api_gateway_method_settings",
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_api_gateway_stage[%s]'s corresponding aws_api_gateway_method_settings should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_api_gateway_stage[%s]'s corresponding aws_api_gateway_method_settings isn't defined or is null", [name]),
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_stage", name], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource
	api := resource.aws_api_gateway_stage[name]

	methodSettings := resource.aws_api_gateway_method_settings[settingsId]

	settingName := split(methodSettings.stage_name,".")[1]
	settingName == name
	not common_lib.valid_key(methodSettings, "settings")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_stage",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("aws_api_gateway_method_settings[%s]", [settingsId]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_api_gateway_method_settings[%s].settings should be defined and not null", [settingsId]),
		"keyActualValue": sprintf("aws_api_gateway_method_settings[%s].settings isn't defined or is null", [settingsId]),
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_method_settings", settingsId], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource
	api := resource.aws_api_gateway_stage[name]

	methodSettings := resource.aws_api_gateway_method_settings[settingsId]

	settingName := split(methodSettings.stage_name,".")[1]
	settingName == name
	settings := methodSettings.settings
	not common_lib.valid_key(settings, "logging_level")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_stage",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("aws_api_gateway_method_settings[%s].settings", [settingsId]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_api_gateway_method_settings[%s].settings.logging_level should be defined and not null", [settingsId]),
		"keyActualValue": sprintf("aws_api_gateway_method_settings[%s].settings.logging_level isn't defined or is null", [settingsId]),
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_method_settings", settingsId], ["settings"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource
	api := resource.aws_api_gateway_stage[name]

	methodSettings := resource.aws_api_gateway_method_settings[settingsId]

	settingName := split(methodSettings.stage_name,".")[1]
	settingName == name
	settings := methodSettings.settings
	loggingLevel := settings.logging_level
	loggingLevel == ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_stage",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("aws_api_gateway_method_settings[%s].settings.logging_level", [settingsId]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_api_gateway_method_settings[%s].settings.logging_level should be defined and not null", [settingsId]),
		"keyActualValue": sprintf("aws_api_gateway_method_settings[%s].settings.logging_level isn't defined or is null", [settingsId]),
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_method_settings", settingsId], ["settings", "logging_level"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource
	api := resource.aws_api_gateway_stage[name]

	methodSettings := resource.aws_api_gateway_method_settings[settingsId]

	settingName := split(methodSettings.stage_name,".")[1]
	settingName == name
	settings := methodSettings.settings

	loggingLevel := settings.logging_level
	loggingLevel == "OFF"

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_stage",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("aws_api_gateway_method_settings[%s].settings.logging_level", [settingsId]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("aws_api_gateway_method_settings[%s].settings.logging_level should not be set to OFF", [settingsId]),
		"keyActualValue": sprintf("aws_api_gateway_method_settings[%s].settings.logging_level is set to OFF", [settingsId]),
		"searchLine": common_lib.build_search_line(["resource", "aws_api_gateway_method_settings", settingsId], ["settings", "logging_level"]),
	}
}
