package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGatewayV2::Stage"

	properties := resource.Properties
	not common_lib.valid_key(resource.Properties, "AccessLogSettings")
	not common_lib.valid_key(resource.Properties, "DefaultRouteSettings")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AccessLogSettings or Resources.%s.Properties.DefaultRouteSettings should be defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AccessLogSettings and Resources.%s.Properties.DefaultRouteSettings are undefined or null", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGatewayV2::Stage"

	properties := resource.Properties
	not common_lib.valid_key(resource.Properties, "AccessLogSettings")
	defaultRouteSettings := resource.Properties.DefaultRouteSettings
	not common_lib.valid_key(defaultRouteSettings, "LoggingLevel")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.DefaultRouteSettings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AccessLogSettings or Resources.%s.Properties.DefaultRouteSettings.LoggingLevel should be defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AccessLogSettings and Resources.%s.Properties.DefaultRouteSettings.LoggingLevel are undefined or null", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGatewayV2::Stage"

	properties := resource.Properties
	not common_lib.valid_key(resource.Properties, "AccessLogSettings")
	loggingLevel := resource.Properties.DefaultRouteSettings.LoggingLevel
	loggingLevel == "OFF"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.DefaultRouteSettings.LoggingLevel", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AccessLogSettings should be defined and not null or Resources.%s.Properties.DefaultRouteSettings.LoggingLevel should not be set to OFF", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AccessLogSettings is undefined or null and Resources.%s.Properties.DefaultRouteSettings.LoggingLevel is OFF", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Stage"

	properties := resource.Properties
	not common_lib.valid_key(resource.Properties, "AccessLogSettings")
	not common_lib.valid_key(resource.Properties, "DefaultRouteSettings")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AccessLogSettings or Resources.%s.Properties.DefaultRouteSettings should be defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AccessLogSettings and Resources.%s.Properties.DefaultRouteSettings are undefined or null", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Stage"

	properties := resource.Properties
	not common_lib.valid_key(resource.Properties, "AccessLogSettings")
	defaultRouteSettings := resource.Properties.DefaultRouteSettings
	not common_lib.valid_key(defaultRouteSettings, "LoggingLevel")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.DefaultRouteSettings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AccessLogSettings or Resources.%s.Properties.DefaultRouteSettings.LoggingLevel should be defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AccessLogSettings and Resources.%s.Properties.DefaultRouteSettings.LoggingLevel are undefined or null", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Stage"

	properties := resource.Properties
	not common_lib.valid_key(resource.Properties, "AccessLogSettings")
	loggingLevel := resource.Properties.DefaultRouteSettings.LoggingLevel
	loggingLevel == "OFF"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.DefaultRouteSettings.LoggingLevel", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.AccessLogSettings should be defined and not null or Resources.%s.Properties.DefaultRouteSettings.LoggingLevel should not be set to OFF", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.AccessLogSettings is undefined or null and Resources.%s.Properties.DefaultRouteSettings.LoggingLevel is OFF", [name]),
	}
}