package Cx

CxPolicy[result] {
	metadata := input.document[i].metadata
	container := input.document[i].spec.containers[c]
	input.document[i].kind == "Pod"
	object.get(container.resources.requests, "memory", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.containers.name=%s.resources.requests", [metadata.name, container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("spec.containers[%s].resources.requests.memory is defined", [container.name]),
		"keyActualValue": sprintf("spec.containers[%s].resources.requests.memory is not defined", [container.name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].metadata
	container := input.document[i].spec.containers[c]
	input.document[i].kind == "Pod"
	object.get(container.resources.requests, "cpu", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.containers.name=%s.resources.requests", [metadata.name, container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("spec.containers[%s].resources.requests.cpu is defined", [container.name]),
		"keyActualValue": sprintf("spec.containers[%s].resources.requests.cpu is not defined", [container.name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].metadata
	container := input.document[i].spec.containers[c]
	input.document[i].kind == "Pod"
	object.get(container.resources.limits, "memory", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.containers.name=%s.resources.limits", [metadata.name, container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("spec.containers[%s].resources.limits.memory is defined", [container.name]),
		"keyActualValue": sprintf("spec.containers[%s].resources.limits.memory is not defined", [container.name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].metadata
	container := input.document[i].spec.containers[c]
	input.document[i].kind == "Pod"
	object.get(container.resources.limits, "cpu", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.containers.name=%s.resources.limits", [metadata.name, container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("spec.containers[%s].resources.limits.cpu is defined", [container.name]),
		"keyActualValue": sprintf("spec.containers[%s].resources.limits.cpu is not defined", [container.name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].metadata
	container := input.document[i].spec.containers[c]
	input.document[i].kind == "Pod"
	container.resources.requests.memory != container.resources.limits.memory

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.containers.name=%s.resources", [metadata.name, container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.containers[%s].resources.requests.memory is equal to spec.containers[%s].resources.limits.memory", [container.name, container.name]),
		"keyActualValue": sprintf("spec.containers[%s].resources.requests.memory is not equal to spec.containers[%s].resources.limits.memory", [container.name, container.name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].metadata
	container := input.document[i].spec.containers[c]
	input.document[i].kind == "Pod"
	container.resources.requests.cpu != container.resources.limits.cpu

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.containers.name=%s.resources", [metadata.name, container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.containers[%s].resources.requests.cpu is equal to spec.containers[%s].resources.limits.cpu", [container.name, container.name]),
		"keyActualValue": sprintf("spec.containers[%s].resources.requests.cpu is not equal to spec.containers[%s].resources.limits.cpu", [container.name, container.name]),
	}
}
