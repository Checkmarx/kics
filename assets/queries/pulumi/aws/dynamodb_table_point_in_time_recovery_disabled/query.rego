package Cx

import data.generic.common as common_lib
import data.generic.pulumi as plm_lib

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:dynamodb:Table"

	not common_lib.valid_key(resource.properties, "pointInTimeRecovery")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'pointInTimeRecovery' should be defined",
		"keyActualValue": "Attribute 'pointInTimeRecovery' is not defined",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:dynamodb:Table"

	pointInTimeRecovery := resource.properties.pointInTimeRecovery
	pointInTimeRecovery.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties.pointInTimeRecovery.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'enabled' in 'pointInTimeRecovery' should be set to true",
		"keyActualValue": "Attribute 'enabled' in 'pointInTimeRecovery'  is set to false",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], ["pointInTimeRecovery", "enabled"]),
	}
}
