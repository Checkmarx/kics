package Cx

CxPolicy[result] {
	metadata := input.document[i].metadata
	spec := input.document[i].spec
	containers := spec.containers
	limits := containers[c].resources.limits
	exists_memory := object.get(limits, "memory", "undefined") != "undefined"
	not exists_memory

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.containers[%d].name=%s.resources.limits.memory", [metadata.name, c, containers[c].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.containers[%d].name=%s.resources.limits.memory is defined", [metadata.name, c, containers[c].name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.containers[%d].name=%s.resources.limits.memory is undefined", [metadata.name, c, containers[c].name]),
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
		"searchKey": sprintf("metadata.name={{%s}}.spec.containers[%d].name=%s.resources", [metadata.name, c, containers[c].name]),
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
	exists_limits := object.get(resources, "limits", "undefined") != "undefined"
	not exists_limits

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.containers[%d].name=%s.resources.limits", [metadata.name, c, containers[c].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.containers[%d].name=%s.resources.limits are defined", [metadata.name, c, containers[c].name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.containers[%d].name=%s.resources.limits are undefined", [metadata.name, c, containers[c].name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].metadata
	spec := input.document[i].spec
	initContainers := spec.initContainers
	limits := initContainers[c].resources.limits
	exists_memory := object.get(limits, "memory", "undefined") != "undefined"
	not exists_memory

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.initContainers[%d].name=%s.resources.limits.memory", [metadata.name, c, initContainers[c].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.initContainers[%d].name=%s.resources.limits.memory is defined", [metadata.name, c, initContainers[c].name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.initContainers[%d].name=%s.resources.limits.memory is undefined", [metadata.name, c, initContainers[c].name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].metadata
	spec := input.document[i].spec
	exists_containers := object.get(spec, "initContainers", "undefined") != "undefined"
	exists_containers

	initContainers := spec.initContainers
	exists_resources := object.get(initContainers[c], "resources", "undefined") != "undefined"
	not exists_resources

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.initContainers[%d].name=%s.resources", [metadata.name, c, initContainers[c].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.initContainers[%d].name=%s.resources are defined", [metadata.name, c, initContainers[c].name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.initContainers[%d].name=%s.resources are undefined", [metadata.name, c, initContainers[c].name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].metadata
	spec := input.document[i].spec
	exists_containers := object.get(spec, "initContainers", "undefined") != "undefined"
	exists_containers

	initContainers := spec.initContainers
	exists_resources := object.get(initContainers[c], "resources", "undefined") != "undefined"
	exists_resources

	resources := spec.initContainers[c].resources
	exists_limits := object.get(resources, "limits", "undefined") != "undefined"
	not exists_limits

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.initContainers[%d].name=%s.resources.limits", [metadata.name, c, initContainers[c].name]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.initContainers[%d].name=%s.resources.limits are defined", [metadata.name, c, initContainers[c].name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.initContainers[%d].name=%s.resources.limits are undefined", [metadata.name, c, initContainers[c].name]),
	}
}
