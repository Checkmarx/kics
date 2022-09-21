package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties, "monitoringService")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'monitoringService' should be defined and not null",
		"keyActualValue": "'monitoringService' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	resource.properties.monitoringService == "none"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.monitoringService", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'monitoringService' to not be 'none'",
		"keyActualValue": "'monitoringService' is 'none'", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "monitoringService"], []),
	}
}

