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
	not k8sLib.hasFlag(container, "--anonymous-auth=false")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "--anonymous-auth flag should be set to false",
		"keyActualValue": "--anonymous-auth flag is not set to false",
	}
}
