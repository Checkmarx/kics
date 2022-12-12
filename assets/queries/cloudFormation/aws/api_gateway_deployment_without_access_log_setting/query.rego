package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib


CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Deployment"

	not check_resources_type("AWS::ApiGateway::Stage")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s should have Stage defined", [name]),
		"keyActualValue": sprintf("Resources.%s doesn't have Stage defined", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Deployment"

	check_resources_type("AWS::ApiGateway::Stage")
	not settings_are_equal(document[i].Resources, name)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources.%s should have AWS::ApiGateway::Stage associated, DeploymentId.Ref should be the same as the ApiGateway::Stage resource", [name]),
		"keyActualValue": sprintf("Resources.%s should have AWS::ApiGateway::Stage associated, DeploymentId.Ref should be the same in the ApiGateway::Stage resource", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Deployment"

	check_resources_type("AWS::ApiGateway::Stage")
	settings_are_equal(document[i].Resources, name)

	not common_lib.valid_key(resource.Properties, "StageDescription")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.StageDescription", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StageDescription should be defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.StageDescription is not defined", [name]),
	}
}

CxPolicy[result] {
	document := input.document
	resource = document[i].Resources[name]
	resource.Type == "AWS::ApiGateway::Deployment"

	check_resources_type("AWS::ApiGateway::Stage")
	settings_are_equal(document[i].Resources, name)

	not common_lib.valid_key(resource.Properties.StageDescription, "AccessLogSetting")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("Resources.%s.Properties.StageDescription.AccessLogSetting", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.Properties.StageDescriptionAccessLogSetting should be defined", [name]),
		"keyActualValue": sprintf("Resources.%s.Properties.StageDescription.AccessLogSetting is not defined", [name]),
	}
}

check_resources_type(resourceType) {
	resource := input.document[_].Resources
	resource[_].Type == resourceType
}

settings_are_equal(resource, deploymentName) {
	resource[_].Type == "AWS::ApiGateway::Stage"
	resource[_].Properties.DeploymentId.Ref == deploymentName
}
