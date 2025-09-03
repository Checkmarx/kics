package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGatewayV2::Stage"

	properties := resource.Properties
	not common_lib.valid_key(properties, "DefaultRouteSettings")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"searchValue": "DefaultRouteSettings",
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DefaultRouteSettings should be defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DefaultRouteSettings are undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGatewayV2::Stage"

	properties := resource.Properties
	defaultRouteSettings := properties.DefaultRouteSettings
	not common_lib.valid_key(defaultRouteSettings, "LoggingLevel")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.DefaultRouteSettings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DefaultRouteSettings.LoggingLevel should be defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DefaultRouteSettings.LoggingLevel are undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "DefaultRouteSettings"], []),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGatewayV2::Stage"

	properties := resource.Properties
	loggingLevel := properties.DefaultRouteSettings.LoggingLevel
	loggingLevel == ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.DefaultRouteSettings.LoggingLevel", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DefaultRouteSettings.LoggingLevel should not be empty", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DefaultRouteSettings.LoggingLevel is empty", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "DefaultRouteSettings", "LoggingLevel"], []),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGatewayV2::Stage"

	properties := resource.Properties
	loggingLevel := properties.DefaultRouteSettings.LoggingLevel
	loggingLevel == "OFF"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.DefaultRouteSettings.LoggingLevel", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DefaultRouteSettings.LoggingLevel should not be set to OFF", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DefaultRouteSettings.LoggingLevel is OFF", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "DefaultRouteSettings", "LoggingLevel"], []),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Stage"

	properties := resource.Properties
	not common_lib.valid_key(properties, "MethodSettings")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"searchValue": "MethodSettings",
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.MethodSettings should be defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.MethodSettings are undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Stage"

	properties := resource.Properties
	methodSettings := properties.MethodSettings
	not common_lib.valid_key(methodSettings, "LoggingLevel")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.MethodSettings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.MethodSettings.LoggingLevel should be defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.MethodSettings.LoggingLevel are undefined or null", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "MethodSettings"], []),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Stage"

	properties := resource.Properties
	loggingLevel := properties.MethodSettings.LoggingLevel
	loggingLevel == ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.MethodSettings.LoggingLevel", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.MethodSettings.LoggingLevel should be not be empty", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.MethodSettings.LoggingLevel is empty", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "MethodSettings", "LoggingLevel"], []),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Stage"

	properties := resource.Properties
	loggingLevel := properties.MethodSettings.LoggingLevel
	loggingLevel == "OFF"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.MethodSettings.LoggingLevel", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.MethodSettings.LoggingLevel should not be set to OFF", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.MethodSettings.LoggingLevel is OFF", [name]),
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties", "MethodSettings", "LoggingLevel"], []),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.Resources[name]
	resource.Type == "AWS::ApiGatewayV2::Stage"
	properties := resource.Properties

	not properties.AccessLogSettings

	result := {
		"documentId": doc.id,
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'AccessLogSettings' should be defined",
		"keyActualValue": "'AccessLogSettings' is not defined",
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"searchValue": "AccessLogSettings",
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}

CxPolicy[result] {
	doc := input.document[i]
	resource := doc.Resources[name]
	resource.Type == "AWS::ApiGateway::Stage"
	properties := resource.Properties

	not properties.AccessLogSetting

	result := {
		"documentId": doc.id,
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'AccessLogSetting' should be defined",
		"keyActualValue": "'AccessLogSetting' is not defined",
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties", [name]),
		"searchValue": "AccessLogSetting",
		"searchLine": common_lib.build_search_line(["Resources", name, "Properties"], []),
	}
}
