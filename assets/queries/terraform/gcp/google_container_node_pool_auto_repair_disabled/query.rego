package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	nodePool := input.document[i].resource.google_container_node_pool[name]
	nodePool.management.auto_repair == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_node_pool",
		"resourceName": tf_lib.get_resource_name(nodePool, name),
		"searchKey": sprintf("google_container_node_pool[%s].management.auto_repair", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("google_container_node_pool[%s].management.auto_repair should be true", [name]),
		"keyActualValue": sprintf("google_container_node_pool[%s].management.auto_repair is false", [name]),
		"searchLine": common_lib.build_search_line(["resource", "google_container_node_pool", name],["management", "auto_repair"]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	nodePool := input.document[i].resource.google_container_node_pool[name]
	not common_lib.valid_key(nodePool, "management")

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_node_pool",
		"resourceName": tf_lib.get_resource_name(nodePool, name),
		"searchKey": sprintf("google_container_node_pool[%s].management", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("google_container_node_pool[%s].management.auto_repair should be defined and not null", [name]),
		"keyActualValue": sprintf("google_container_node_pool[%s].management.auto_repair is undefined or null", [name]),
		"remediation": "management {\n\t\tauto_repair = true\n\t}\n",
		"remediationType": "addition",
	}
}
