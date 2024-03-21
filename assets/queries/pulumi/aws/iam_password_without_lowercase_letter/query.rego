package Cx

import data.generic.common as common_lib
import data.generic.pulumi as plm_lib

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:iam:AccountPasswordPolicy"

	not common_lib.valid_key(resource.properties, "requireLowercaseCharacters")


	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'requireLowercaseCharacters' should be defined and set to true",
		"keyActualValue": "Attribute 'requireLowercaseCharacters' is not defined",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "aws:iam:AccountPasswordPolicy"

	requireLowercaseCharacters := resource.properties.requireLowercaseCharacters
	requireLowercaseCharacters == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties.requireLowercaseCharacters", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'requireLowercaseCharacters' should be set to true",
		"keyActualValue": "Attribute 'requireLowercaseCharacters' is set to false",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], ["requireLowercaseCharacters"]),
	}
}
