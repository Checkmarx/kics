package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	resource := input.document[i]
	specInfo := k8sLib.getSpecInfo(resource)
	container := specInfo.spec.containers[j]

	inArray(container.command, "kubelet")
	containerArgs := object.get(container, "args", {})
	not inArray(containerArgs, "--read-only-port=0")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("spec.container[%d].args", [j]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--read-only-port flag to exists and to be '0' in container.args",
		"keyActualValue": "--read-only-port flag does not exists or is not set to '0' in container.args",
	}
}

inArray(arr, value) {
	arr[_] == value
}