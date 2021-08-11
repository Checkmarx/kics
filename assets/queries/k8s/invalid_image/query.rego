package Cx

import data.generic.common as common_lib

types := {"initContainers", "containers"}

CxPolicy[result] {
	document := input.document
	metadata := document[i].metadata
	spec := document[i].spec
	containers := spec[types[x]]
	not common_lib.valid_key(containers[c], "image")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.%s.name=%s", [metadata.name, types[x], containers[c].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.%s.name=%s.image is defined and not null", [metadata.name, types[x], containers[c].name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.%s.name=%s.image is undefined or null", [metadata.name, types[x], containers[c].name]),
	}
}

CxPolicy[result] {
	document := input.document
	metadata := document[i].metadata
	spec := document[i].spec
	containers := spec[types[x]]
	images = containers[c].image
	check_content(images)

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.%s.name=%s.image", [metadata.name, types[x], containers[c].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.%s.name=%s.image is not null, empty or latest", [metadata.name, types[x], containers[c].name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.%s.name=%s.image is null, empty or latest", [metadata.name, types[x], containers[c].name]),
	}
}

check_content(images) {
	options := {"", "latest"}

	images == options[j]
}
