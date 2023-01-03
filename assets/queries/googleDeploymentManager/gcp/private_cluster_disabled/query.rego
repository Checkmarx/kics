package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties, "privateClusterConfig")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'privateClusterConfig' should be defined and not null",
		"keyActualValue": "'privateClusterConfig' is undefined or null",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties"], []),
	}
}

fields := {"enablePrivateEndpoint", "enablePrivateNodes"}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties.privateClusterConfig, fields[f])

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.privateClusterConfig", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("'%s' should be defined and not null", [fields[f]]),
		"keyActualValue":  sprintf("'%s' is undefined or null", [fields[f]]),
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "privateClusterConfig"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	resource.properties.privateClusterConfig[fields[f]] == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.privateClusterConfig.%s", [resource.name, fields[f]]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s' should be set to true", [fields[f]]),
		"keyActualValue":  sprintf("'%s' is set to false", [fields[f]]),
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "privateClusterConfig", fields[f]], []),
	}
}
