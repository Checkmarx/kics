package Cx

CxPolicy[result] {
	metadata := input.document[i].metadata
	types := {"initContainers", "containers"}
	container := input.document[i].spec[types[x]][c]
	input.document[i].kind == "Pod"
	object.get(container.resources.requests, "memory", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.%s.name=%s.resources.requests", [metadata.name, types[x], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("spec.%s[%s].resources.requests.memory is defined", [types[x], container.name]),
		"keyActualValue": sprintf("spec.%s[%s].resources.requests.memory is not defined", [types[x], container.name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].metadata
	types := {"initContainers", "containers"}
	container := input.document[i].spec[types[x]][c]
	input.document[i].kind == "Pod"
	object.get(container.resources.requests, "cpu", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.%s.name=%s.resources.requests", [metadata.name, types[x], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("spec.%s[%s].resources.requests.cpu is defined", [types[x], container.name]),
		"keyActualValue": sprintf("spec.%s[%s].resources.requests.cpu is not defined", [types[x], container.name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].metadata
	types := {"initContainers", "containers"}
	container := input.document[i].spec[types[x]][c]
	input.document[i].kind == "Pod"
	object.get(container.resources.limits, "memory", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.%s.name=%s.resources.limits", [metadata.name, types[x], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("spec.%s[%s].resources.limits.memory is defined", [types[x], container.name]),
		"keyActualValue": sprintf("spec.%s[%s].resources.limits.memory is not defined", [types[x], container.name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].metadata
	types := {"initContainers", "containers"}
	container := input.document[i].spec[types[x]][c]
	input.document[i].kind == "Pod"
	object.get(container.resources.limits, "cpu", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.%s.name=%s.resources.limits", [metadata.name, types[x], container.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("spec.%s[%s].resources.limits.cpu is defined", [types[x], container.name]),
		"keyActualValue": sprintf("spec.%s[%s].resources.limits.cpu is not defined", [types[x], container.name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].metadata
	types := {"initContainers", "containers"}
	container := input.document[i].spec[types[x]][c]
	input.document[i].kind == "Pod"
	container.resources.requests.memory != container.resources.limits.memory

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.%s.name=%s.resources", [metadata.name, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.%s[%s].resources.requests.memory is equal to spec.%s[%s].resources.limits.memory", [types[x], container.name, types[x], container.name]),
		"keyActualValue": sprintf("spec.%s[%s].resources.requests.memory is not equal to spec.%s[%s].resources.limits.memory", [types[x], container.name, types[x], container.name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].metadata
	types := {"initContainers", "containers"}
	container := input.document[i].spec[types[x]][c]
	input.document[i].kind == "Pod"
	container.resources.requests.cpu != container.resources.limits.cpu

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.%s.name=%s.resources", [metadata.name, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.%s[%s].resources.requests.cpu is equal to spec.%s[%s].resources.limits.cpu", [types[x], container.name, types[x], container.name]),
		"keyActualValue": sprintf("spec.%s[%s].resources.requests.cpu is not equal to spec.%s[%s].resources.limits.cpu", [types[x], container.name, types[x], container.name]),
	}
}
