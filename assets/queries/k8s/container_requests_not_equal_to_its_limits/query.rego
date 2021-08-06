package Cx

import data.generic.common as common_lib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	document.kind == "Pod"
	container := document.spec[types[x]][c]
	rec := {"requests", "limits"}

	not common_lib.valid_key(container.resources[rec[t]], "memory")

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
	container := document.spec[types[x]][c]
	rec := {"requests", "limits"}

	not common_lib.valid_key(container.resources[rec[t]], "cpu")

	result := {
		"documentId": document.id,
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
	rec := {"cpu", "memory"}

	container.resources.requests[rec[t]] != container.resources.limits[rec[t]]

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.resources", [document.metadata.name, types[x], container.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.%s[%s].resources.requests.%s is equal to spec.%s[%s].resources.limits.%s", [types[x], container.name, rec[t], types[x], container.name, rec[t]]),
		"keyActualValue": sprintf("spec.%s[%s].resources.requests.%s is not equal to spec.%s[%s].resources.limits.%s", [types[x], container.name, rec[t], types[x], container.name, rec[t]]),
	}
}
