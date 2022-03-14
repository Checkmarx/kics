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
 	not hasFlag(container, "--read-only-port=0")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--read-only-port flag to exists and to be '0' in container",
		"keyActualValue": "--read-only-port flag does not exists or is not set to '0' in container",
	}
}

hasFlag(container, flag) {
	common_lib.inArray(container.command, flag)
} else {
	common_lib.inArray(container.args, flag)
}
