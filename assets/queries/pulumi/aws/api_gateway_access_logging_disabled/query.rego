package Cx

import data.generic.common as common_lib
import data.generic.pulumi as plm_lib

valid_types := ["aws:apigateway:Stage", "aws:apigatewayv2:Stage"]

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == valid_types[_]

	not common_lib.valid_key(resource.properties, "accessLogSettings")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'accessLogSettings' should be defined",
		"keyActualValue": "Attribute 'accessLogSettings' is not defined",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:apigatewayv2:Stage"

	not common_lib.valid_key(resource.properties, "defaultRouteSettings")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties", [name]),
		"searchValue": "defaultRouteSettings",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'defaultRouteSettings' should be defined",
		"keyActualValue": "Attribute 'defaultRouteSettings' is not defined",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:apigatewayv2:Stage"

	defaultRouteSettings := resource.properties.defaultRouteSettings
	not common_lib.valid_key(defaultRouteSettings, "loggingLevel")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties.defaultRouteSettings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'defaultRouteSettings.loggingLevel' should be defined",
		"keyActualValue": "Attribute 'defaultRouteSettings.loggingLevel' is not defined",
		"searchLine": common_lib.build_search_line(["resources", name, "properties", "defaultRouteSettings"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:apigatewayv2:Stage"

	loggingLevel := resource.properties.defaultRouteSettings.loggingLevel
	loggingLevel == ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties.defaultRouteSettings.loggingLevel", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'defaultRouteSettings.loggingLevel' should not be empty",
		"keyActualValue": "Attribute 'defaultRouteSettings.loggingLevel' is empty",
		"searchLine": common_lib.build_search_line(["resources", name, "properties", "defaultRouteSettings", "loggingLevel"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:apigatewayv2:Stage"

	loggingLevel := resource.properties.defaultRouteSettings.loggingLevel
	loggingLevel == "OFF"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties.defaultRouteSettings.loggingLevel", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'defaultRouteSettings.loggingLevel' should not be set to OFF",
		"keyActualValue": "Attribute 'defaultRouteSettings.loggingLevel' is set to OFF",
		"searchLine": common_lib.build_search_line(["resources", name, "properties", "defaultRouteSettings", "loggingLevel"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:apigateway:Stage"

	not common_lib.valid_key(resource.properties, "methodSettings")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties", [name]),
		"searchValue": "methodSettings",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'methodSettings' should be defined",
		"keyActualValue": "Attribute 'methodSettings' is not defined",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:apigateway:Stage"

	methodSetting := resource.properties.methodSettings[j]
	not common_lib.valid_key(methodSetting, "loggingLevel")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties.methodSettings", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Attribute 'methodSettings[%d].loggingLevel' should be defined", [j]),
		"keyActualValue": sprintf("Attribute 'methodSettings[%d].loggingLevel' is not defined", [j]),
		"searchLine": common_lib.build_search_line(["resources", name, "properties", "methodSettings", j], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:apigateway:Stage"

	loggingLevel := resource.properties.methodSettings[j].loggingLevel
	loggingLevel == ""

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties.methodSettings[%d].loggingLevel", [name, j]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Attribute 'methodSettings[%d].loggingLevel' should not be empty", [j]),
		"keyActualValue": sprintf("Attribute 'methodSettings[%d].loggingLevel' is empty", [j]),
		"searchLine": common_lib.build_search_line(["resources", name, "properties", "methodSettings", j, "loggingLevel"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:apigateway:Stage"

	loggingLevel := resource.properties.methodSettings[j].loggingLevel
	loggingLevel == "OFF"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties.methodSettings[%d].loggingLevel", [name, j]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Attribute 'methodSettings[%d].loggingLevel' should not be set to OFF", [j]),
		"keyActualValue": sprintf("Attribute 'methodSettings[%d].loggingLevel' is set to OFF", [j]),
		"searchLine": common_lib.build_search_line(["resources", name, "properties", "methodSettings", j, "loggingLevel"], []),
	}
}
