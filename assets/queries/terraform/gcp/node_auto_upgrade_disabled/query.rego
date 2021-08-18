package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_container_node_pool[name]
	not common_lib.valid_key(resource, "management")
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_container_node_pool[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "google_container_node_pool.management is defined and not null",
		"keyActualValue": "google_container_node_pool.management is undefined or null",
	}
}

CxPolicy[result] {
	management := input.document[i].resource.google_container_node_pool[name].management
	not common_lib.valid_key(management, "auto_upgrade")
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_container_node_pool[%s].management", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "management.auto_upgrade is defined and not null",
		"keyActualValue": "management.auto_upgrade is undefined or null",
	}
}

CxPolicy[result] {
	management := input.document[i].resource.google_container_node_pool[name].management
	management.auto_upgrade == false
	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_container_node_pool[%s].management.auto_upgrade", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "management.auto_upgrade is true",
		"keyActualValue": "management.auto_upgrade is false",
	}
}
