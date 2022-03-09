package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	resource := input.document[i]
	specInfo := k8sLib.getSpecInfo(resource)
	container := specInfo.spec.containers[j]
	commands := ["kube-apiserver", "kubelet"]

	inArray(container.command, commands[_])
	containerArgs := object.get(container, "args", {})
	startswith(containerArgs[a], "--authorization-mode")
	modes := split(containerArgs[a], "=")[1]
	hasMode(modes, "AlwaysAllow")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("spec.container[%d].args", [j]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--authorization-mode flag to not have 'AlwaysAllow' mode",
		"keyActualValue": "--authorization-mode flag contains 'AlwaysAllow' mode",
	}
}

inArray(arr, value) {
	arr[_] == value
}

hasMode(modes, mode) {
	splittedModes := split(modes, ",")
	splittedModes[_] == mode
}
