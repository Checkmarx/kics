package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

# Checks if Properties.AccessLogSettings exists for "AWS::ApiGatewayV2::Stage"
CxPolicy[result] {
	doc := input.document[i]
	resource := doc.Resources[stage]
	resource.Type == "AWS::ApiGatewayV2::Stage"
	
	properties := resource.Properties
	not properties.DefaultRouteSettings
	not properties.AccessLogSettings

	result := {
		"documentId": doc.id,
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'AccessLogSettings' should be defined",
		"keyActualValue": "'AccessLogSettings' is not defined",
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, stage),
		"searchKey": sprintf("Resources.%s.Properties", [stage]),
	}
}

# Checks if Properties.AccessLogSettings exists for "AWS::ApiGateway::Stage"
CxPolicy[result] {
	doc := input.document[i]
	resource := doc.Resources[stage]
	resource.Type == "AWS::ApiGateway::Stage"
	properties := resource.Properties

	not properties.AccessLogSetting

	result := {
		"documentId": doc.id,
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'AccessLogSetting' should be defined",
		"keyActualValue": "'AccessLogSetting' is not defined",
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, stage),
		"searchKey": sprintf("Resources.%s.Properties", [stage]),
	}
}

# Checks if ProtocolType == WEBSOCKET for AWS::ApiGatewayV2::Api & Properties.DefaultRouteSettings Key exists for "AWS::ApiGatewayV2::Stage"
CxPolicy[result] {
	document := input.document
	api_resource := document[i].Resources[_]
	api_resource.Type == "AWS::ApiGatewayV2::Api"
	api_resource.Properties.ProtocolType == "WEBSOCKET"
	
	stage_resource := document[i].Resources[name]
	stage_resource.Type == "AWS::ApiGatewayV2::Stage"
	properties := stage_resource.Properties
	not properties.AccessLogSettings
	searchKeyValid := common_lib.valid_non_empty_key(properties, "DefaultRouteSettings")
	
	result := {
		"documentId": input.document[i].id,
		"resourceType": stage_resource.Type,
		"resourceName": cf_lib.get_resource_name(stage_resource, name),
		"searchKey": sprintf("Resources.%s.Properties%s", [name, searchKeyValid]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DefaultRouteSettings should be defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DefaultRouteSettings are undefined or null", [name]),
	}
}

# Checks if ProtocolType == WEBSOCKET for AWS::ApiGatewayV2::Api & Properties.DefaultRouteSettings.LoggingLevel Key exists for "AWS::ApiGatewayV2::Stage"
CxPolicy[result] {
	document := input.document
	api_resource := document[i].Resources[_]
	api_resource.Type == "AWS::ApiGatewayV2::Api"
	api_resource.Properties.ProtocolType == "WEBSOCKET"
    
	stage_resource := document[i].Resources[name]
	stage_resource.Type == "AWS::ApiGatewayV2::Stage"
	properties := stage_resource.Properties
	defaultRouteSettings := properties.DefaultRouteSettings
	searchKeyValid := common_lib.valid_non_empty_key(defaultRouteSettings, "LoggingLevel")

	result := {
		"documentId": input.document[i].id,
		"resourceType": stage_resource.Type,
		"resourceName": cf_lib.get_resource_name(stage_resource, name),
		"searchKey": sprintf("Resources.%s.Properties.DefaultRouteSettings%s", [name, searchKeyValid]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DefaultRouteSettings.LoggingLevel should be defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DefaultRouteSettings.LoggingLevel are undefined or null", [name]),
	}
}

# Checks if ProtocolType == WEBSOCKET for AWS::ApiGatewayV2::Api & properties.DefaultRouteSettings.LoggingLevel == OFF for "AWS::ApiGatewayV2::Stage"
CxPolicy[result] {
	document := input.document
	
	api_resource := document[i].Resources[_]
	api_resource.Type == "AWS::ApiGatewayV2::Api"
	api_resource.Properties.ProtocolType == "WEBSOCKET"
    
	stage_resource := document[i].Resources[name]
	stage_resource.Type == "AWS::ApiGatewayV2::Stage"
    stage_properties := stage_resource.Properties
	stage_properties.DefaultRouteSettings.LoggingLevel == "OFF"
    not stage_properties.AccessLogSettings

	result := {
		"documentId": input.document[i].id,
		"resourceType": stage_resource.Type,
		"resourceName": cf_lib.get_resource_name(stage_resource, name),
		"searchKey": sprintf("Resources.%s.Properties.DefaultRouteSettings.LoggingLevel", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s.Properties.DefaultRouteSettings.LoggingLevel should be defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.DefaultRouteSettings.LoggingLevel is OFF", [name]),
	}
}

# Checks if properties.MethodSettings Key exists for "AWS::ApiGateway::Stage"
CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Stage"

	properties := resource.Properties
	searchKeyValid := common_lib.valid_non_empty_key(properties, "MethodSettings")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties%s", [name, searchKeyValid]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.MethodSettings should be defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.MethodSettings are undefined or null", [name]),
	}
}

# Checks if properties.MethodSettings.LoggingLevel Key exists for "AWS::ApiGateway::Stage"
CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Stage"

	properties := resource.Properties
	methodSettings := properties.MethodSettings
	searchKeyValid := common_lib.valid_non_empty_key(methodSettings, "LoggingLevel")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.MethodSettings%s", [name, searchKeyValid]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.MethodSettings.LoggingLevel should be defined and not null", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.MethodSettings.LoggingLevel are undefined or null", [name]),
	}
}

# Checks if properties.MethodSettings.LoggingLevel == OFF for "AWS::ApiGateway::Stage"
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
	}
}
