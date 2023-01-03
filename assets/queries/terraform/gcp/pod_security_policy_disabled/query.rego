package Cx

import data.generic.terraform as tf_lib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	not resource.pod_security_policy_config

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s]", [primary]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'pod_security_policy_config' should be defined",
		"keyActualValue": "Attribute 'pod_security_policy_config' is undefined",
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", primary],[]),
		"remediation": "pod_security_policy_config {\n\t\tenabled = true\n\t}\n",
		"remediationType": "addition",
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
		"searchKey": sprintf("google_container_cluster[%s].pod_security_policy_config.enabled", [primary]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Attribute 'enabled' of 'pod_security_policy_config' should be true",
		"keyActualValue": "Attribute 'enabled' of 'pod_security_policy_config' is false",
		"searchLine": common_lib.build_search_line(["resource", "google_container_cluster", primary],["pod_security_policy_config", "enabled"]),
		"remediation": json.marshal({
			"before": "false",
			"after": "true"
		}),
		"remediationType": "replacement",
	}
}
