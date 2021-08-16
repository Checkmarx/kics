package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	not common_lib.valid_key(resource, "private_cluster_config")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_container_cluster[%s]", [primary]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'private_cluster_config' is defined and not null",
		"keyActualValue": "Attribute 'private_cluster_config' is undefined or null",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]

	resource.private_cluster_config
	not bothDefined(resource.private_cluster_config)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_container_cluster[%s].private_cluster_config", [primary]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'private_cluster_config.enable_private_endpoint' is defined and Attribute 'private_cluster_config.enable_private_nodes' is defined",
		"keyActualValue": "Attribute 'private_cluster_config.enable_private_endpoint' is undefined or Attribute 'private_cluster_config.enable_private_nodes' is undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]

	bothDefined(resource.private_cluster_config)
	not bothTrue(resource.private_cluster_config)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("google_container_cluster[%s].private_cluster_config", [primary]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'private_cluster_config.enable_private_endpoint' is true and Attribute 'private_cluster_config.enable_private_nodes' is true",
		"keyActualValue": "Attribute 'private_cluster_config.enable_private_endpoint' is false or Attribute 'private_cluster_config.enable_private_nodes' is false",
	}
}

bothDefined(private_cluster_config) {
	common_lib.valid_key(private_cluster_config, "enable_private_endpoint")
	common_lib.valid_key(private_cluster_config, "enable_private_nodes")
}

bothTrue(private_cluster_config) {
	private_cluster_config.enable_private_endpoint == true
	private_cluster_config.enable_private_nodes == true
}
