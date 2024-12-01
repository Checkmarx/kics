package Cx

import data.generic.terraform as tf_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	google_container_cluster := document.resource.google_container_cluster[name]
	google_container_cluster.enable_shielded_nodes == false

	result := {
		"documentId": document.id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(google_container_cluster, name),
		"searchKey": sprintf("google_container_cluster[%s].enable_shielded_nodes", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "google_container_cluster.enable_shielded_nodes should be set to true",
		"keyActualValue": "google_container_cluster.enable_shielded_nodes is set to false",
	}
}
