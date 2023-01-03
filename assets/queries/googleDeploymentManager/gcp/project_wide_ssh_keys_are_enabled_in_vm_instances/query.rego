package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "compute.v1.instance"

	not common_lib.valid_key(resource.properties, "metadata")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'metadata' should be defined and not null",
		"keyActualValue": "'metadata' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "compute.v1.instance"

	not haveField(resource.properties.metadata.items, "block-project-ssh-keys")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.metadata.items", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'metadata.items' should have 'block-project-ssh-keys'",
		"keyActualValue": "'metadata.items' does not have 'block-project-ssh-keys'", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "metadata", "items"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "compute.v1.instance"

	resource.properties.metadata.items[j].key == "block-project-ssh-keys"
	resource.properties.metadata.items[j].value == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.metadata.items[%d].key", [resource.name, j]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'metadata.items[%d].value' should be true", [j]),
		"keyActualValue": sprintf("'metadata.items[%d].value' is false", [j]), 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "metadata", "items", j, "value"], []),
	}
}

haveField(items, field) {
	items[i].key == field
}
