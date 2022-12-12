package Cx

import data.generic.common as common_lib
import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_container_node_pool[name]
	not common_lib.valid_key(resource, "management")
	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_node_pool",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("google_container_node_pool[%s]", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "google_container_node_pool.management should be defined and not null",
		"keyActualValue": "google_container_node_pool.management is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "google_container_node_pool", name],[]),
		"remediation": "management {\n\t\tauto_upgrade = true\n\t}\n",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	management := input.document[i].resource.google_container_node_pool[name].management
	not common_lib.valid_key(management, "auto_upgrade")
	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_node_pool",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_container_node_pool[name], name),
		"searchKey": sprintf("google_container_node_pool[%s].management", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "management.auto_upgrade should be defined and not null",
		"keyActualValue": "management.auto_upgrade is undefined or null",
		"searchLine": common_lib.build_search_line(["resource", "google_container_node_pool", name],["management"]),
		"remediation": "auto_upgrade = true",
		"remediationType": "addition",
	}
}

CxPolicy[result] {
	management := input.document[i].resource.google_container_node_pool[name].management
	management.auto_upgrade == false
	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_node_pool",
		"resourceName": tf_lib.get_resource_name(input.document[i].resource.google_container_node_pool[name], name),
		"searchKey": sprintf("google_container_node_pool[%s].management.auto_upgrade", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "management.auto_upgrade should be true",
		"keyActualValue": "management.auto_upgrade is false",
		"searchLine": common_lib.build_search_line(["resource", "google_container_node_pool", name],["management", "auto_upgrade"]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
