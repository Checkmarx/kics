package Cx

import data.generic.k8s as k8sLib
import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	specInfo := k8sLib.getSpecInfo(resource)
	container := specInfo.spec.containers[j]

	inArray(container.command, "kube-apiserver")
	containerArgs := object.get(container, "args", {})
	inArray(containerArgs, "--anonymous-auth=true")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("spec.container[%d].args", [j]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--anonymous-auth flag should be set to false",
		"keyActualValue": "--anonymous-auth flag is set to true",
	}
}

CxPolicy[result] {
	resource := input.document[i]
	specInfo := k8sLib.getSpecInfo(resource)
	container := specInfo.spec.containers[j]

	inArray(container.command, "kube-apiserver")
	containerArgs := object.get(container, "args", {})
	not inArray(containerArgs, "--anonymous-auth=false")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("spec.container[%d].args", [j]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "--anonymous-auth flag should be set to false",
		"keyActualValue": "--anonymous-auth flag is not set",
	}
}

inArray(arr, value) {
	arr[_] == value
}
