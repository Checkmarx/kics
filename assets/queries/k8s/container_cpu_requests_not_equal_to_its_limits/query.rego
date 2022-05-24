package Cx

import data.generic.common as common_lib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	document.kind == "Pod"
	container := document.spec[types[x]][c]
	rec := {"requests", "limits"}

	not common_lib.valid_key(container.resources[rec[t]], "cpu")

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": document.metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.resources.%s", [document.metadata.name, types[x], container.name, rec[t]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("spec.%s[%s].resources.%s.cpu is defined", [types[x], container.name, rec[t]]),
		"keyActualValue": sprintf("spec.%s[%s].resources.%s.cpu is not defined", [types[x], container.name, rec[t]]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	document.kind == "Pod"
	container := document.spec[types[x]][c]

	container.resources.requests.cpu != container.resources.limits.cpu

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": document.metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.resources", [document.metadata.name, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.%s[%s].resources.requests.cpu is equal to spec.%s[%s].resources.limits.cpu", [types[x], container.name, types[x], container.name]),
		"keyActualValue": sprintf("spec.%s[%s].resources.requests.cpu is not equal to spec.%s[%s].resources.limits.cpu", [types[x], container.name, types[x], container.name]),
	}
}
