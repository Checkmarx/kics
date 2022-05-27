package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	not resource.pod_security_policy_config

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s]", [primary]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'pod_security_policy_config' is defined",
		"keyActualValue": "Attribute 'pod_security_policy_config' is undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	resource.pod_security_policy_config
	resource.pod_security_policy_config.enabled == false

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s].pod_security_policy_config", [primary]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'enabled' of 'pod_security_policy_config' is true",
		"keyActualValue": "Attribute 'enabled' of 'pod_security_policy_config' is false",
	}
}
