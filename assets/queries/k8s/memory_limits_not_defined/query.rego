package Cx

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	spec := document.spec

	containers := spec[types[t]][c]

	limits := containers.resources.limits
	object.get(limits, "memory", "undefined") == "undefined"

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.resources.limits", [metadata.name, types[t], containers.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.resources.limits.memory is defined", [metadata.name, types[t], containers.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.resources.limits.memory is undefined", [metadata.name, types[t], containers.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	spec := document.spec

	containers := spec[types[t]][c]

	object.get(containers, "resources", "undefined") == "undefined"
	metadata := document.metadata

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}", [metadata.name, types[t], containers.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.resources are defined", [metadata.name, types[t], containers.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.resources are undefined", [metadata.name, types[t], containers.name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	spec := document.spec

	containers := spec[types[t]][c]

	resources := containers.resources
	object.get(resources, "limits", "undefined") == "undefined"

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.resources", [metadata.name, types[t], containers.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.resources.limits are defined", [metadata.name, types[t], containers.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.resources.limits are undefined", [metadata.name, types[t], containers.name]),
	}
}
