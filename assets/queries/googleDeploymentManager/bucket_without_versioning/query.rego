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
		"keyExpectedValue": "'versioning' should be defined and not null",
		"keyActualValue": "'versioning' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "storage.v1.bucket"

	not common_lib.valid_key(resource.properties.versioning, "enabled")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.versioning", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'versioning.enabled' should be defined and not null",
		"keyActualValue": "'versioning.enabled' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "versioning"], []),
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
		"keyExpectedValue": "'versioning.enabled' should be true",
		"keyActualValue": "'versioning.enabled' is false", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "versioning", "enabled"], []),
	}
}
