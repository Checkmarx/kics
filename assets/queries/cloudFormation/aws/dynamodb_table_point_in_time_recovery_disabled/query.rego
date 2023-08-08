package Cx

import data.generic.common as common_lib
import data.generic.cloudformation as cf_lib

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::DynamoDB::Table"
	properties := resource.Properties
	properties.PointInTimeRecoverySpecification == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties.PointInTimeRecoverySpecification", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources[%s].Properties.PointInTimeRecoverySpecification should be 'true'", [key]),
		"keyActualValue": sprintf("Resources[%s].Properties.PointInTimeRecoverySpecification is 'false'", [key]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	resource := document.Resources[key]
	resource.Type == "AWS::DynamoDB::Table"
	properties := resource.Properties

	not common_lib.valid_key(properties, "PointInTimeRecoverySpecification")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources[%s].Properties.PointInTimeRecoverySpecification should be set and to 'true'", [key]),
		"keyActualValue": sprintf("Resources[%s].Properties.PointInTimeRecoverySpecification is not set", [key]),
	}
}
