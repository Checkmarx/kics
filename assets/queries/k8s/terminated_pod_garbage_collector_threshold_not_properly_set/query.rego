package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

CxPolicy[result] {
	resource := input.document[i]
	metadata := resource.metadata
	specInfo := k8sLib.getSpecInfo(resource)
	types := {"initContainers", "containers"}
	container := specInfo.spec[types[x]][j]
	common_lib.inArray(container.command, "kube-controller-manager")
	k8sLib.startWithFlag(container, "--terminated-pod-gc-threshold")
	not k8sLib.hasFlagBetweenValues(container, "--terminated-pod-gc-threshold", 0, 12501)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.%s.name={{%s}}.command", [metadata.name, specInfo.path, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--terminated-pod-gc-threshold flag should be set to 10",
		"keyActualValue": "--terminated-pod-gc-threshold flag is set to a incorrect value",
		"searchLine": common_lib.build_search_line(split(specInfo.path, "."), [types[x], j, "command"]),
	}
}
