package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties, "nodePools")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'nodePools' should be defined and not null",
		"keyActualValue": "'nodePools' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties.nodePools, "management")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.nodePools", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'nodePools.management' should be defined and not null",
		"keyActualValue": "'nodePools.management' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "nodePools"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties.nodePools.management, "autoUpgrade")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.nodePools.management", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'nodePools.management.autoUpgrade' should be defined and not null",
		"keyActualValue": "'nodePools.management.autoUpgrade' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "nodePools", "management"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	resource.properties.nodePools.management.autoUpgrade == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.nodePools.management.autoUpgrade", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'nodePools.management.autoUpgrade' should be true",
		"keyActualValue": "'nodePools.management.autoUpgrade' is false", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "nodePools", "management", "autoUpgrade"], []),
	}
}
