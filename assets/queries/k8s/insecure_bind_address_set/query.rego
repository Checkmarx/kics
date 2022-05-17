package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]

	common_lib.inArray(container.command, "kube-apiserver")
	k8sLib.startWithFlag(container, "--insecure-bind-address")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--insecure-bind-address flag should not be set",
		"keyActualValue": "--insecure-bind-address flag is set",
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"])
	}
}

