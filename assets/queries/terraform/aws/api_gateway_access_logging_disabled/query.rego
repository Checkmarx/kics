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
	_ := input.document[i].resource.aws_api_gateway_stage[name]

	x := [methodSettings | methodSettings := input.document[i].resource.aws_api_gateway_method_settings[_];
    		split(methodSettings.stage_name,".")[1]==name]

	count(x) == 0
	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_stage",
		"searchKey": sprintf("aws_api_gateway_stage[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_api_gateway_stage[%s]'s corresponding aws_api_gateway_method_settings should be defined and not null", [name]),
		"keyActualValue": sprintf("aws_api_gateway_stage[%s]'s corresponding aws_api_gateway_method_settings isn't defined or is null", [name]),
	}
}


CxPolicy[result] {
    resource := input.document[i].resource
	api := resource.aws_api_gateway_stage[name]

	methodSettings := resource.aws_api_gateway_method_settings[settingsId]

    settingName := split(methodSettings.stage_name,".")[1]
    settingName == name
	searchKeyValid := validNonEmptyKey(methodSettings, "settings")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_stage",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("aws_api_gateway_method_settings[%s]%s", [settingsId, searchKeyValid]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_api_gateway_method_settings[%s].settings should be defined and not null", [settingsId]),
		"keyActualValue": sprintf("aws_api_gateway_method_settings[%s].settings isn't defined or is null", [settingsId]),
	}
}

CxPolicy[result] {
    resource := input.document[i].resource
	api := resource.aws_api_gateway_stage[name]

	methodSettings := resource.aws_api_gateway_method_settings[settingsId]

    settingName := split(methodSettings.stage_name,".")[1]
    settingName == name
	settings := methodSettings.settings
	searchKeyValid := validNonEmptyKey(settings, "logging_level")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "aws_api_gateway_stage",
		"resourceName": tf_lib.get_resource_name(api, name),
		"searchKey": sprintf("aws_api_gateway_method_settings[%s].settings%s", [settingsId, searchKeyValid]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_api_gateway_method_settings[%s].settings.logging_level should be defined and not null", [settingsId]),
		"keyActualValue": sprintf("aws_api_gateway_method_settings[%s].settings.logging_level isn't defined or is null", [settingsId]),
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
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("aws_api_gateway_method_settings[%s].settings.logging_level should not be set to OFF", [settingsId]),
		"keyActualValue": "aws_api_gateway_method_settings[%s].settings.logging_level is set to OFF",
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
