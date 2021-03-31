package Cx

import data.generic.common as commonLib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	document.kind == "Pod"
	metadata := document.metadata
	spec := document.spec
	containers := spec[types[x]]
	capabilities := spec.containers[k].securityContext.capabilities
	not commonLib.compareArrays(capabilities.drop, ["ALL", "NET_RAW"])

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.securityContext.capabilities.drop", [metadata.name, types[x], containers[k].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.securityContext.capabilities.drop is ALL or NET_RAW", [metadata.name, types[x], containers[k].name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.securityContext.capabilities.drop is not ALL or NET_RAW", [metadata.name, types[x], containers[k].name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	document.kind == "Pod"
	metadata := document.metadata
	spec := document.spec
	containers := spec[types[x]]

	object.get(spec.containers[k].securityContext.capabilities, "drop", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.securityContext.capabilities", [metadata.name, types[x], containers[k].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.securityContext.capabilities.drop is set", [metadata.name, types[x], containers[k].name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.securityContext.capabilities.drop is undefined", [metadata.name, types[x], containers[k].name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	document.kind == "Pod"
	metadata := document.metadata
	spec := document.spec
	containers := spec[types[x]]

	object.get(spec.containers[k].securityContext, "capabilities", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.securityContext", [metadata.name, types[x], containers[k].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.securityContext.capabilities is set", [metadata.name, types[x], containers[k].name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.securityContext.capabilities is undefined", [metadata.name, types[x], containers[k].name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	document.kind == "Pod"
	metadata := document.metadata
	spec := document.spec
	containers := spec[types[x]]

	object.get(spec.containers[k], "securityContext", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name=%s", [metadata.name, types[x], containers[k].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.%s.name=%s.securityContext is set", [metadata.name, types[x], containers[k].name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.%s.name=%s.securityContext is undefined", [metadata.name, types[x], containers[k].name]),
	}
}
