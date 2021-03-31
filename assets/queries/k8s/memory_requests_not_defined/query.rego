package Cx

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	spec := document.spec

	containers := spec[types[t]][c]

	requests := containers.resources.requests
	object.get(requests, "memory", "undefined") == "undefined"

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.resources.requests", [metadata.name, types[t], containers.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.resources.requests.memory is defined", [metadata.name, types[t], containers.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.resources.requests.memory is undefined", [metadata.name, types[t], containers.name]),
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
	object.get(resources, "requests", "undefined") == "undefined"

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.resources", [metadata.name, types[t], containers.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.resources.requests are defined", [metadata.name, types[t], containers.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.resources.requests are undefined", [metadata.name, types[t], containers.name]),
	}
}
