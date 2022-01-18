package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"

	not common_lib.valid_key(resource.properties, "masterAuth")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "'masterAuth' is defined and not null",
		"keyActualValue": "'masterAuth' is undefined or null", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"
	masterAuth := resource.properties.masterAuth

	not bothDefined(masterAuth)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties.masterAuth", [resource.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'masterAuth.username' to be defined and Attribute 'masterAuth.password' to be defined",
		"keyActualValue": "Attribute 'masterAuth.username' is undefined Attribute 'masterAuth.password' is undefined", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "masterAuth"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resources[idx]
	resource.type == "container.v1.cluster"
	masterAuth := resource.properties.masterAuth

	not bothFilled(masterAuth)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("resources.name={{%s}}.properties.masterAuth", [resource.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'masterAuth.username' to be not empty and Attribute 'masterAuth.password' to be not empty",
		"keyActualValue": "Attribute 'masterAuth.username' is empty Attribute 'masterAuth.password' is empty", 
		"searchLine": common_lib.build_search_line(["resources", idx, "properties", "masterAuth"], []),
	}
}

bothDefined(masterAuth) {
	masterAuth.username
	masterAuth.password
}

bothFilled(masterAuth) {
	count(masterAuth.username) > 0
	count(masterAuth.password) > 0
}
