package Cx

import data.generic.common as common_lib
import data.generic.pulumi as plm_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resources[name]
	resource.type == "aws:iam:AccountPasswordPolicy"

	not common_lib.valid_key(resource.properties, "minimumPasswordLength")

	result := {
		"documentId": document.id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'minimumPasswordLength' should be defined and set to 14 or higher",
		"keyActualValue": "Attribute 'minimumPasswordLength' is not defined",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], []),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resources[name]
	resource.type == "aws:iam:AccountPasswordPolicy"

	minimumPasswordLength := resource.properties.minimumPasswordLength
	minimumPasswordLength < 14

	result := {
		"documentId": document.id,
		"resourceType": resource.type,
		"resourceName": plm_lib.getResourceName(resource, name),
		"searchKey": sprintf("resources[%s].properties.minimumPasswordLength", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'minimumPasswordLength' should be set to 14 or higher",
		"keyActualValue": "Attribute 'minimumPasswordLength' is set to less than 14",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], ["minimumPasswordLength"]),
	}
}
