package Cx

CxPolicy[result] {
	document := input.document
	metadata := document[i].metadata
	spec := document[i].spec
	types := {"initContainers", "containers"}
	containers := spec[types[x]]
	object.get(containers[c], "image", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.%s.name=%s", [metadata.name, types[x], containers[c].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.%s.name=%s.image is defined", [metadata.name, types[x], containers[c].name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.%s.name=%s.image is undefined", [metadata.name, types[x], containers[c].name]),
	}
}

CxPolicy[result] {
	document := input.document
	metadata := document[i].metadata
	spec := document[i].spec
	types := {"initContainers", "containers"}
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
	images == ""
}

check_content(images) {
	images == "latest"
}

check_content(images) {
	images == null
}
