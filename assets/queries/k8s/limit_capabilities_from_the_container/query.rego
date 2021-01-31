package Cx

CxPolicy[result] {
	metadata := input.document[i].metadata
	spec := input.document[i].spec
	types := {"initContainers", "containers"}
	containers := spec[types[x]]
	drop := containers[c].securityContext.capabilities.drop

	not contains(drop, "ALL")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.%s.name=%s.securityContext.capabilities.drop", [metadata.name, types[x], containers[c].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("In metadata.name=%s.spec.%s.name=%s.securityContext.capabilities.drop, 'ALL' should be listed ", [metadata.name, types[x], containers[c].name]),
		"keyActualValue": sprintf("In metadata.name=%s.spec.%s.name=%s.securityContext.capabilities.drop, 'ALL' is not listed", [metadata.name, types[x], containers[c].name]),
	}
}

contains(drop, elem) {
	drop[_] = elem
}
