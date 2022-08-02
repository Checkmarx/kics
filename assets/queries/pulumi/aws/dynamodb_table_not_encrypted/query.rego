package Cx

import data.generic.common as common_lib
import data.generic.pulumi as plm_lib

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:dynamodb:Table"

	not common_lib.valid_key(resource.properties, "serverSideEncryption")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'serverSideEncryption' should be defined",
		"keyActualValue": "Attribute 'serverSideEncryption' is not defined",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:dynamodb:Table"

	serverSideEncryption := resource.properties.serverSideEncryption
	serverSideEncryption.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties.serverSideEncryption.enabled", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'enabled' in 'serverSideEncryption' should be set to true",
		"keyActualValue": "Attribute 'enabled' in 'serverSideEncryption'  is set to false",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], ["serverSideEncryption", "enabled"]),
	}
}
