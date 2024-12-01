package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties, "masterAuth")

	result := {
		"documentId": document.id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'masterAuth' should be defined and not null",
		"keyActualValue": "'masterAuth' is undefined or null",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties"], []),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties.masterAuth, "username")
	not common_lib.valid_key(resource.properties.masterAuth, "password")

	result := {
		"documentId": document.id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.masterAuth", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'masterAuth.username' should be defined and Attribute 'masterAuth.password' should be defined",
		"keyActualValue": "Attribute 'masterAuth.username' is undefined or attribute 'masterAuth.password' is undefined",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "masterAuth"], []),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resources[idx]
	resource.type == "container.v1.cluster"

	not count(resource.properties.masterAuth.username) > 0
	not count(resource.properties.masterAuth.password) > 0

	result := {
		"documentId": document.id,
		"resourceType": resource.type,
		"resourceName": resource.name,
		"searchKey": sprintf("resources.name={{%s}}.properties.masterAuth", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'masterAuth.username' should not be empty and attribute 'masterAuth.password' should not be empty",
		"keyActualValue": "Attribute 'masterAuth.username' is empty or attribute 'masterAuth.password' is empty",
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "masterAuth"], []),
	}
}
