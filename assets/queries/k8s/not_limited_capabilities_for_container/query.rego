package Cx

CxPolicy[result] {
	metadata := input.document[i].metadata
	spec := input.document[i].spec
	containers := spec.containers
	drop := containers[c].securityContext.capabilities.drop

	not contains(drop, "ALL")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.containers.name=%s.securityContext.capabilities.drop", [metadata.name, containers[c].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("All metadata.name=%s.spec.containers.name=%s.securityContext.capabilities.drop must be dropped", [metadata.name, containers[c].name]),
		"keyActualValue": sprintf("Are not being metadata.name=%s.spec.containers.name=%s.securityContext.capabilities.drop dropped", [metadata.name, containers[c].name]),
	}
}

contains(drop, elem) {
	drop[_] = elem
}
