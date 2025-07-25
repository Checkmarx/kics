package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::DynamoDB::Table"
	properties := resource.Properties
	properties.SSESpecification.SSEType == "KMS"
	cf_lib.isCloudFormationFalse(properties.SSESpecification.SSEEnabled)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.properties;", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources[%s].properties.SSESpecification.SSEEnabled should be true", [key]),
		"keyActualValue": sprintf("Resources[%s].properties.SSESpecification.SSEEnabled is false", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::DynamoDB::Table"
	properties := resource.Properties
	not common_lib.valid_key(properties, "SSESpecification")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.properties;", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.properties.SSESpecification should be set", [key]),
		"keyActualValue": sprintf("Resources.%s.properties.SSESpecification is undefined", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::DynamoDB::Table"
	properties := resource.Properties

	not common_lib.valid_key(properties.SSESpecification, "SSEEnabled")
	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.properties;", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources.%s.properties.SSESpecification.SSEEnabled should be set", [key]),
		"keyActualValue": sprintf("Resources.%s.properties.SSESpecification.SSEEnabled is undefined", [key]),
	}
}
