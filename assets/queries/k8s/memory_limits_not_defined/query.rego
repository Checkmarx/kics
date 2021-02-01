package Cx

CxPolicy[result] {
	metadata := input.document[i].metadata
	spec := input.document[i].spec
	types := {"initContainers", "containers"}
	containers := spec[types[x]]
	limits := containers[c].resources.limits
	exists_memory := object.get(limits, "memory", "undefined") != "undefined"
	not exists_memory

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.%s[%d].name=%s.resources.limits.memory", [metadata.name, types[x], c, containers[c].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.%s[%d].name=%s.resources.limits.memory is defined", [metadata.name, types[x], c, containers[c].name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.%s[%d].name=%s.resources.limits.memory is undefined", [metadata.name, types[x], c, containers[c].name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].metadata
	spec := input.document[i].spec
	types := {"initContainers", "containers"}
	exists_containers := object.get(spec, types[x], "undefined") != "undefined"
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
	types := {"initContainers", "containers"}
	exists_containers := object.get(spec, types[x], "undefined") != "undefined"
	exists_containers

	containers := spec[types[x]]
	exists_resources := object.get(containers[c], "resources", "undefined") != "undefined"
	not exists_resources

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.%s[%d].name=%s.resources", [metadata.name, types[x], c, containers[c].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.%s[%d].name=%s.resources are defined", [metadata.name, types[x], c, containers[c].name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.%s[%d].name=%s.resources are undefined", [metadata.name, types[x], c, containers[c].name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].metadata
	spec := input.document[i].spec
	types := {"initContainers", "containers"}
	exists_containers := object.get(spec, types[x], "undefined") != "undefined"
	exists_containers

	containers := spec[types[x]]
	exists_resources := object.get(containers[c], "resources", "undefined") != "undefined"
	exists_resources

	resources := spec.containers[c].resources
	exists_limits := object.get(resources, "limits", "undefined") != "undefined"
	not exists_limits

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.%s[%d].name=%s.resources.limits", [metadata.name, types[x], c, containers[c].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.%s[%d].name=%s.resources.limits are defined", [metadata.name, types[x], c, containers[c].name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.%s[%d].name=%s.resources.limits are undefined", [metadata.name, types[x], c, containers[c].name]),
	}
}
