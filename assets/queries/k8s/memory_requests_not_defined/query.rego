package Cx

CxPolicy[result] {
	metadata := input.document[i].metadata
	spec := input.document[i].spec
	containers := spec.containers
	requests := containers[c].resources.requests
	exists_memory := object.get(requests, "memory", "undefined") != "undefined"
	not exists_memory

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.containers[%d].name=%s.resources.requests.memory", [metadata.name, c, containers[c].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.containers[%d].name=%s.resources.requests.memory is defined", [metadata.name, c, containers[c].name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.containers[%d].name=%s.resources.requests.memory is undefined", [metadata.name, c, containers[c].name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].metadata
	spec := input.document[i].spec
	exists_containers := object.get(spec, "containers", "undefined") != "undefined"
	not exists_containers

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec", [metadata.name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec is defined", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.spec is undefined", [metadata.name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].metadata
	spec := input.document[i].spec
	exists_containers := object.get(spec, "containers", "undefined") != "undefined"
	exists_containers

	containers := spec.containers
	exists_resources := object.get(containers[c], "resources", "undefined") != "undefined"
	not exists_resources

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.containers[%d].name=%s.resources", [metadata.name, c, containers[c].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.containers[%d].name=%s.resources are defined", [metadata.name, c, containers[c].name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.containers[%d].name=%s.resources are undefined", [metadata.name, c, containers[c].name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].metadata
	spec := input.document[i].spec
	exists_containers := object.get(spec, "containers", "undefined") != "undefined"
	exists_containers

	containers := spec.containers
	exists_resources := object.get(containers[c], "resources", "undefined") != "undefined"
	exists_resources

	resources := spec.containers[c].resources
	exists_requests := object.get(resources, "requests", "undefined") != "undefined"
	not exists_requests

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.containers[%d].name=%s.resources.requests", [metadata.name, c, containers[c].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.containers[%d].name=%s.resources.requests are defined", [metadata.name, c, containers[c].name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.containers[%d].name=%s.resources.requests are undefined", [metadata.name, c, containers[c].name]),
	}
}
