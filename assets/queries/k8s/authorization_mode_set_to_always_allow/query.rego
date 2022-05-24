package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]
	commands := ["kube-apiserver", "kubelet"]

	common_lib.inArray(container.command, commands[_])
	k8sLib.hasFlagWithValue(container, "--authorization-mode", "AlwaysAllow")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--authorization-mode flag to not have 'AlwaysAllow' mode",
		"keyActualValue": "--authorization-mode flag contains 'AlwaysAllow' mode",
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "KubeletConfiguration"

	resource.authorization.mode == "AlwaysAllow"

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": "n/a",
		"searchKey": "kind={{KubeletConfiguration}}.authorization.mode",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "authorization.mode attribute should not be 'AlwaysAllow'",
		"keyActualValue": "authorization.mode attribute is equal to 'AlwaysAllow'",
	}
}

