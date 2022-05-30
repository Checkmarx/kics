package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	commands := ["kube-apiserver", "kubelet"]
	container := specInfo.spec[types[x]][j]

	common_lib.inArray(container.command, commands[_])
	k8sLib.hasFlag(container, "--anonymous-auth=true")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--anonymous-auth flag should be set to false",
		"keyActualValue": "--anonymous-auth flag is set to true",
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "KubeletConfiguration"

	resource.authentication.anonymous.enabled != false

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": "n/a",
		"searchKey": "kind={{KubeletConfiguration}}.authentication.enabled",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "authentication.anonymous.enabled attribute should be false",
		"keyActualValue": "authentication.anonymous.enabled attribute is true",
	}
}
