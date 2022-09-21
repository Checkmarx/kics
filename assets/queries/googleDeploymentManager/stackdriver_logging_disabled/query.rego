package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties, "loggingService")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'loggingService' should be defined and not null",
		"keyActualValue": "'loggingService' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	resource.properties.loggingService == "none"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.loggingService", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'loggingService' to not be none",
		"keyActualValue": "'loggingService' is none", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "loggingService"], []),
	}
}
