package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[key]
	resource.Type == "AWS::ApiGateway::Stage"

	properties := resource.Properties

	not common_lib.valid_key(properties, "MethodSettings")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.MethodSettings should be defined", [key]),
		"keyActualValue": sprintf("Resources.%s.Properties.MethodSettings is undefined", [key]),
		"searchLine": common_lib.build_search_line(["Resources", key, "Properties"], []),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[key]
	resource.Type == "AWS::ApiGateway::Stage"

	methods := resource.Properties.MethodSettings
	method := methods[idx]
	not common_lib.valid_key(method, "MetricsEnabled")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties.MethodSettings", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.MethodSettings[%d].MetricsEnabled should be set to true", [key, idx]),
		"keyActualValue": sprintf("Resources.%s.Properties.MethodSettings[%d].MetricsEnabled is undefined", [key, idx]),
		"searchLine": common_lib.build_search_line(["Resources", key, "Properties", "MethodSettings"], [idx]),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.Resources[key]
	resource.Type == "AWS::ApiGateway::Stage"

	methods := resource.Properties.MethodSettings
	method := methods[idx]
	method.MetricsEnabled == "false"

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties.MethodSettings", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.MethodSettings[%d].MetricsEnabled should be set to true", [key, idx]),
		"keyActualValue": sprintf("Resources.%s.Properties.MethodSettings[%d].MetricsEnabled is set to false", [key, idx]),
		"searchLine": common_lib.build_search_line(["Resources", key, "Properties", "MethodSettings", idx], ["MetricsEnabled"]),
	}
}
