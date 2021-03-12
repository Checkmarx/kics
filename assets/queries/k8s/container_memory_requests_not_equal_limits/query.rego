package Cx

CxPolicy[result] {
	document := input.document[i]
	document.kind == "Pod"
	types := {"initContainers", "containers"}
	container := document.spec[types[x]][c]
	rec := {"requests", "limits"}

	object.get(container.resources[rec[t]], "memory", "undefined") == "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.resources.%s", [document.metadata.name, types[x], container.name, rec[t]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("spec.%s[%s].resources.%s.memory is defined", [types[x], container.name, rec[t]]),
		"keyActualValue": sprintf("spec.%s[%s].resources.%s.memory is not defined", [types[x], container.name, rec[t]]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	document.kind == "Pod"
	types := {"initContainers", "containers"}
	container := document.spec[types[x]][c]

	container.resources.requests.memory != container.resources.limits.memory

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.resources", [document.metadata.name, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.%s[%s].resources.requests.memory is equal to spec.%s[%s].resources.limits.memory", [types[x], container.name, types[x], container.name]),
		"keyActualValue": sprintf("spec.%s[%s].resources.requests.memory is not equal to spec.%s[%s].resources.limits.memory", [types[x], container.name, types[x], container.name]),
	}
}
