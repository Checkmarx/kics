package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_container_node_pool[name]

	resource.node_config.image_type
	not startswith(lower(resource.node_config.image_type), "cos")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_node_pool",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_node_pool[%s].node_config.image_type", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'node_config.image_type' should start with 'COS'",
		"keyActualValue": "'node_config.image_type' does not start with 'COS'",
	}
}
