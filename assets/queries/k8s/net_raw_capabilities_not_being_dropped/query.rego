package Cx

import data.generic.common as common_lib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	document.kind == "Pod"
	metadata := document.metadata
	spec := document.spec
	containers := spec[types[x]]
	capabilities := spec.containers[k].securityContext.capabilities
	not common_lib.compareArrays(capabilities.drop, ["ALL", "NET_RAW"])

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

	not common_lib.valid_key(spec.containers[k].securityContext.capabilities, "drop")

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

	not common_lib.valid_key(spec.containers[k].securityContext, "capabilities")

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

	not common_lib.valid_key(spec.containers[k], "securityContext")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name=%s", [metadata.name, types[x], containers[k].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.%s.name=%s.securityContext is set", [metadata.name, types[x], containers[k].name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.%s.name=%s.securityContext is undefined", [metadata.name, types[x], containers[k].name]),
	}
}
