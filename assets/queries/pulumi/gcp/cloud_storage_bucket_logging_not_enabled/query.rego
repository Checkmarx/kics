package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "gcp:storage:Bucket"

	not common_lib.valid_key(resource.properties, "logging")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": name,
		"searchKey": sprintf("resources[%s].properties", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Storage Bucket should have attribute 'logging' defined",
		"keyActualValue": "Storage Bucket attribute 'logging' is not defined",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[name]
	resource.type == "gcp:storage:Bucket"

	resource.properties.logging.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": name,
		"searchKey": sprintf("resources[%s].properties.logging.enabled", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Storage Bucket should have attribute 'logging.enabled' set to true",
		"keyActualValue": "Storage Bucket attribute 'logging.enabled' is set to false",
		"searchLine": common_lib.build_search_line(["resources", name, "properties"], ["logging", "enabled"]),
	}
}
