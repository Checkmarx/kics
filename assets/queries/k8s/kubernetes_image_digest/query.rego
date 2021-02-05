package Cx

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	spec := document.spec
	containers := spec.containers
	image := containers[c].image
	not contains(image, "@")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.containers.name=%s.image", [metadata.name, containers[c].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.containers.name=%s.image has '@'", [metadata.name, containers[c].name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.containers.name=%s.image should have '@'", [metadata.name, containers[c].name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	spec := document.spec
	containers := spec.containers
	object.get(containers[k], "image", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.containers", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.containers.name=%s.image is defined", [metadata.name, containers[c].name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.containers.name=%s.image is undefined", [metadata.name, containers[c].name]),
	}
}
