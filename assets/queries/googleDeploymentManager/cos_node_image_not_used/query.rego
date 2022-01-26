package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.nodePool"

	not common_lib.valid_key(resource.properties, "config")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'config' to be defined and not null",
		"keyActualValue": "'config' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.nodePool"

	not common_lib.valid_key(resource.properties.config, "imageType")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'config.imageType' to be defined and not null",
		"keyActualValue": "'config.imageType' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "config"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.nodePool"

	not startswith(lower(resource.properties.config.imageType), "cos")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'config.imageType' should start with 'cos'",
		"keyActualValue": sprintf("'config.imageType' is %s", [resource.properties.config.imageType]), 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "config", "cos"], []),
	}
}
