package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name]
	
	not common_lib.valid_key(resource.node_config, "service_account")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_container_cluster[%s].node_config", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'service_account' is not default",
		"keyActualValue": "'service_account' is default",
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name, "node_config"], []),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[name]
	
	contains(resource.node_config.service_account, "default")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_container_cluster[%s].node_config.service_account", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'service_account' is not default",
		"keyActualValue": "'service_account' is default",
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name, "node_config", "service_account"], []),
	}
}
