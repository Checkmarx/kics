package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]

	common_lib.inArray(container.command, "kubelet")
 	k8sLib.startWithFlag(container, "--read-only-port")
	not k8sLib.hasFlag(container, "--read-only-port=0")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--read-only-port flag to and to be '0' in container",
		"keyActualValue": "--read-only-port flag is not set to '0' in container",
	}
}

CxPolicy[result] {
	resource := input.document[i]
	resource.kind == "KubeletConfiguration"

	resource.readOnlyPort != 0

	result := {
		"documentId": input.document[i].id,
		"searchKey": "kind={{KubeletConfiguration}}.readOnlyPort",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "readOnlyPort attribute to have value of 0",
		"keyActualValue": sprintf("readOnlyPort attribute has value of %d", [resource.readOnlyPort]),
	}
}
