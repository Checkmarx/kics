package Cx

import data.generic.cloudformation as cf_lib
import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document	
	resource := document.Resources[key]
	resource.Type == "AWS::DynamoDB::Table"
	properties := resource.Properties

	properties.PointInTimeRecoverySpecification.PointInTimeRecoveryEnabled == false

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties.PointInTimeRecoverySpecification.PointInTimeRecoveryEnabled", [key]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("Resources[%s].Properties.PointInTimeRecoverySpecification.PointInTimeRecoveryEnabled should be set to 'true'", [key]),
		"keyActualValue": sprintf("Resources[%s].Properties.PointInTimeRecoverySpecification.PointInTimeRecoveryEnabled is set to 'false'", [key]),
	}
}

CxPolicy[result] {
	some document in input.document	
	resource := document.Resources[key]
	resource.Type == "AWS::DynamoDB::Table"
	properties := resource.Properties

	not common_lib.valid_key(properties, "PointInTimeRecoverySpecification")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources[%s].Properties.PointInTimeRecoverySpecification.PointInTimeRecoveryEnabled should be defined and set to 'true'", [key]),
		"keyActualValue": sprintf("Resources[%s].Properties.PointInTimeRecoverySpecification is not defined", [key]),
	}
}

CxPolicy[result] {
	some document in input.document	
	resource := document.Resources[key]
	resource.Type == "AWS::DynamoDB::Table"
	properties := resource.Properties
	specification := properties.PointInTimeRecoverySpecification

	not common_lib.valid_key(specification, "PointInTimeRecoveryEnabled")

	result := {
		"documentId": document.id,
		"resourceType": resource.Type,
		"resourceName": cf_lib.get_resource_name(resource, key),
		"searchKey": sprintf("Resources.%s.Properties.PointInTimeRecoverySpecification", [key]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("Resources[%s].Properties.PointInTimeRecoverySpecification.PointInTimeRecoveryEnabled should be defined and set to 'true'", [key]),
		"keyActualValue": sprintf("Resources[%s].Properties.PointInTimeRecoverySpecification.PointInTimeRecoveryEnabled is not defined", [key]),
	}
}
