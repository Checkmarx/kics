package Cx

CxPolicy[result] {
	metadata := input.document[i].metadata
	spec := input.document[i].spec
	containers := spec.containers
	containers[c].securityContext.privileged == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.containers.name=%s.securityContext.privileged", [metadata.name, containers[c].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.containers.name=%s.securityContext.privileged is false", [metadata.name, containers[c].name]),
		"keyActualValue": sprintf("spec.containers.name=%s.securityContext.privileged is true", [metadata.name, containers[c].name]),
	}
}

CxPolicy[result] {
	metadata := input.document[i].metadata
	spec := input.document[i].spec
	initContainers := spec.initContainers
	initContainers[c].securityContext.privileged == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.initContainers.name=%s.securityContext.privileged", [metadata.name, initContainers[c].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.initContainers.name=%s.securityContext.privileged is false", [metadata.name, initContainers[c].name]),
		"keyActualValue": sprintf("spec.initContainers.name=%s.securityContext.privileged is true", [metadata.name, initContainers[c].name]),
	}
}
