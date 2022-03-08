package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	resource := input.document[i]
	container := resource.spec.containers[j]

	inArray(container.command, "kube-apiserver")
	not common_lib.valid_key(container, "args")

	result := {
		"documentId": input.document[i].id,
		"searchKey": "spec.containers.args",
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("spec.containers[%d] should have 'args' attribute", [j]),
		"keyActualValue": sprintf("spec.containers[%d] does not contains 'args' attribute", [j]),
	}
}

CxPolicy[result] {
	resource := input.document[i]
	container := resource.spec.containers[_]

	inArray(container.command, "kube-apiserver")
	inArray(container.args, "--anonymous-auth=true")

	result := {
		"documentId": input.document[i].id,
		"searchKey": "spec.containers.args",
		"issueType": "IncorrectValue",
		"keyExpectedValue": "--anonymous-auth flag should be set to false",
		"keyActualValue": "--anonymous-auth flag is set to true",
	}
}

CxPolicy[result] {
	resource := input.document[i]
	container := resource.spec.containers[_]

	inArray(container.command, "kube-apiserver")
	not inArray(container.args, "--anonymous-auth=false")

	result := {
		"documentId": input.document[i].id,
		"searchKey": "spec.containers.args",
		"issueType": "MissingAttribute",
		"keyExpectedValue": "--anonymous-auth flag should be set to false",
		"keyActualValue": "--anonymous-auth flag is not set",
	}
}

inArray(arr, value) {
	arr[_] == value
}
