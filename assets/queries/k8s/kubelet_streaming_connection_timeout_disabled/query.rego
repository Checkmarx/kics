package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]
	command := "kubelet"

	common_lib.inArray(container.command, command)
	k8sLib.hasFlag(container, "--streaming-connection-idle-timeout=0")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--streaming-connection-idle-timeout flag is not 0",
		"keyActualValue": "--streaming-connection-idle-timeout flag is 0",
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"])
	}
}

CxPolicy[result] {
	resource := input.document[i]
    resource.kind == "KubeletConfiguration"
    resource.streamingConnectionIdleTimeout == "0s"

	result := {
		"documentId": input.document[i].id,
		"searchKey": "kind={{KubeletConfiguration}}.streamingConnectionIdleTimeout",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "streamingConnectionIdleTimeout is not 0s",
		"keyActualValue": "streamingConnectionIdleTimeout is 0s",
	}
}
