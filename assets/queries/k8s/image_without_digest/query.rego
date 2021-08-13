package Cx

import data.generic.common as common_lib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	spec := document.spec
	containers := spec[types[x]]
	image := containers[c].image
	not contains(image, "@")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.image", [metadata.name, types[x], containers[c].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.image has '@'", [metadata.name, types[x], containers[c].name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.image should have '@'", [metadata.name, types[x], containers[c].name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	spec := document.spec
	containers := spec[types[x]]
	cont := containers[k]
	not common_lib.valid_key(cont, "image")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s", [metadata.name, types[x]]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.image is defined", [metadata.name, types[x], containers[c].name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.image is undefined", [metadata.name, types[x], containers[c].name]),
	}
}
