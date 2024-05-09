package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

commandList := {"kube-controller-manager", "kube-scheduler"}

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]
	command := commandList[_]
	common_lib.inArray(container.command, command)
	not k8sLib.hasFlag(container, "--bind-address=127.0.0.1")

	result := {
		"documentId": input.document[i].id,
		"resourceType": resource.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--bind-address flag should not be set to 127.0.0.1",
		"keyActualValue": "--bind-address flag is set to a 127.0.01",
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"]),
	}
}
