package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::DynamoDB::Table"
	properties := resource.Properties
	cf_lib.isCloudFormationFalse(properties.SSESpecification.SSEEnabled)

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties.SSESpecification.SSEEnabled", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources[%s].Properties.SSESpecification.SSEEnabled should be 'true'", [key]),
		"keyActualValue": sprintf("Resources[%s].Properties.SSESpecification.SSEEnabled is 'false'", [key]),
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
		"searchKey": sprintf("Resources.%s.Properties.SSESpecification", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources[%s].Properties.SSESpecification.SSEEnabled should be set and to 'true'", [key]),
		"keyActualValue": sprintf("Resources[%s].Properties.SSESpecification.SSEEnabled is not set", [key]),
	}
}
