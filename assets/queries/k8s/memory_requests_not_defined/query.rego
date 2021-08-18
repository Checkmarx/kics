package Cx

import data.generic.common as common_lib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	spec := document.spec

	containers := spec[types[t]][c]

	requests := containers.resources.requests
	not common_lib.valid_key(requests, "memory")

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

	not common_lib.valid_key(containers, "resources")
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
	not common_lib.valid_key(resources, "requests")

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.resources", [metadata.name, types[t], containers.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.resources.requests are defined", [metadata.name, types[t], containers.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.resources.requests are undefined", [metadata.name, types[t], containers.name]),
	}
}
