package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]

	not bothDefined(resource)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s]", [primary]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'network_policy' should be defined and Attribute 'addons_config' should be defined",
		"keyActualValue": "Attribute 'network_policy' is undefined or Attribute 'addons_config' is undefined",
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", primary],[]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]

	bothDefined(resource)
	not resource.addons_config.network_policy_config

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s].addons_config", [primary]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'addons_config.network_policy_config' should be defined",
		"keyActualValue": "Attribute 'addons_config.network_policy_config' is undefined",
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", primary],["addons_config"]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	resource.network_policy.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s].network_policy.enabled", [primary]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'network_policy.enabled' should be true",
		"keyActualValue": "Attribute 'network_policy.enabled' is false",
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", primary],["network_policy", "enabled"]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	resource.network_policy.enabled == true
	resource.addons_config.network_policy_config.disabled == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s].addons_config.network_policy_config.disabled", [primary]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'addons_config.network_policy_config.disabled' should be set to false",
		"keyActualValue": "Attribute 'addons_config.network_policy_config.disabled' is true",
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", primary],["addons_config", "network_policy_config","disabled"]),
		"remediation": json.marshal({
			"before": "true",
			"after": "false"
		}),
		"remediationType": "replacement",
	}
}

bothDefined(resource) {
	resource.network_policy
	resource.addons_config
}
