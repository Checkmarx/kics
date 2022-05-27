package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]
	metadata := resource.metadata
	metadata.annotations[key]
	expectedKey := "container.apparmor.security.beta.kubernetes.io"
	not startswith(key, expectedKey)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod[%s].metadata.annotations", [name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].metadata.annotations should contain AppArmor profile config: '%s'", [name, expectedKey]),
		"keyActualValue": sprintf("kubernetes_pod[%s].metadata.annotations doesn't contain AppArmor profile config: '%s'", [name, expectedKey]),
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.kubernetes_pod[name]
	metadata := resource.metadata
	not metadata.annotations

	result := {
		"documentId": input.document[i].id,
		"resourceType": "kubernetes_pod",
		"resourceName": tf_lib.get_resource_name(resource, name),
		"searchKey": sprintf("kubernetes_pod[%s].metadata", [name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("kubernetes_pod[%s].metadata should include annotations for AppArmor profile config", [name]),
		"keyActualValue": sprintf("kubernetes_pod[%s].metadata doesn't contain AppArmor profile config in annotations", [name]),
	}
}
