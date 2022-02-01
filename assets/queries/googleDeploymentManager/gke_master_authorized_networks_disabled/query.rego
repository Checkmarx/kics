package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties, "masterAuthorizedNetworksConfig")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'masterAuthorizedNetworksConfig' to be defined and not null",
		"keyActualValue": "'masterAuthorizedNetworksConfig' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties.masterAuthorizedNetworksConfig, "enabled")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties.masterAuthorizedNetworksConfig", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'masterAuthorizedNetworksConfig.enabled' to be defined and not null",
		"keyActualValue": "'masterAuthorizedNetworksConfig.enabled' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "masterAuthorizedNetworksConfig"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	resource.properties.masterAuthorizedNetworksConfig.enabled == false

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties.masterAuthorizedNetworksConfig.enabled", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'masterAuthorizedNetworksConfig.enabled' to be true",
		"keyActualValue": "'masterAuthorizedNetworksConfig.enabled' is false", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "masterAuthorizedNetworksConfig", "enabled"], []),
	}
}
