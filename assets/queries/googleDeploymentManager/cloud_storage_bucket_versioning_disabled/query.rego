package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "storage.v1.bucket"

	not common_lib.valid_key(resource.properties, "versioning")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'versioning' is defined and not null",
		"keyActualValue": "'versioning' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "storage.v1.bucket"

	resource.properties.versioning.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.versioning.enabled", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'enabled' is set to true",
		"keyActualValue": "'enabled' is set to false", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "versioning", "enabled"], []),
	}
}

