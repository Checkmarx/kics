package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	resource := document.resource.google_container_cluster[name]

	not common_lib.valid_key(resource.node_config, "service_account")

	result := {
		"documentId": document.id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s].node_config", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'service_account' should not be default",
		"keyActualValue": "'service_account' is default",
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name, "node_config"], []),
	}
}

CxPolicy[result] {
	some document in input.document
	resource := document.resource.google_container_cluster[name]

	contains(resource.node_config.service_account, "default")

	result := {
		"documentId": document.id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_cluster[%s].node_config.service_account", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'service_account' should not be default",
		"keyActualValue": "'service_account' is default",
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", name, "node_config", "service_account"], []),
	}
}
