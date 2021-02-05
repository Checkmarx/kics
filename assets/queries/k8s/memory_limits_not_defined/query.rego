package Cx

CxPolicy[result] {
	metadata := input.document[i].metadata
	spec := input.document[i].spec
	object.get(spec, "containers", "undefined") != "undefined"

	containers := spec.containers
	object.get(containers[c], "resources", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.initContainers[%d].name=%s.resources", [metadata.name, c, initContainers[c].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.containers[%d].name=%s.resources should be defined", [metadata.name, c, containers[c].name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.containers[%d].name=%s.resources are not defined", [metadata.name, c, containers[c].name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].metadata
	spec := input.document[i].spec
	object.get(spec, "containers", "undefined") != "undefined"

	containers := spec.containers
	object.get(containers[c], "resources", "undefined") != "undefined"

	resources := spec.containers[c].resources
	object.get(resources, "limits", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.initContainers[%d].name=%s.resources.limits", [metadata.name, c, initContainers[c].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.containers[%d].name=%s.resources.limits should be defined", [metadata.name, c, containers[c].name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.containers[%d].name=%s.resources.limits are not defined", [metadata.name, c, containers[c].name]),
	}
}
