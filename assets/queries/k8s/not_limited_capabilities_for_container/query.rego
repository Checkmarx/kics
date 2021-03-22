package Cx

CxPolicy[result] {
	document := input.document[i]
	spec := document.spec
	types := {"initContainers", "containers"}
	containers := spec[types[x]]
	drop := containers[c].securityContext.capabilities.drop

	not contains(drop, "ALL")

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name=%s.spec.%s.name=%s.securityContext.capabilities.drop", [metadata.name, types[x], containers[c].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("In metadata.name=%s.spec.%s.name=%s.securityContext.capabilities.drop, 'ALL' should be listed ", [metadata.name, types[x], containers[c].name]),
		"keyActualValue": sprintf("In metadata.name=%s.spec.%s.name=%s.securityContext.capabilities.drop, 'ALL' is not listed", [metadata.name, types[x], containers[c].name]),
	}
}

CxPolicy[result] {
	document := input.document[i]
	spec := document.spec.template.spec
	types := {"initContainers", "containers"}
	containers := spec[types[x]]
	drop := containers[c].securityContext.capabilities.drop

	not contains(drop, "ALL")

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name=%s.spec.template.spec.%s.name=%s.securityContext.capabilities.drop", [metadata.name, types[x], containers[c].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("In metadata.name=%s.spec.template.spec.%s.name=%s.securityContext.capabilities.drop, 'ALL' should be listed ", [metadata.name, types[x], containers[c].name]),
		"keyActualValue": sprintf("In metadata.name=%s.spec.template.spec.%s.name=%s.securityContext.capabilities.drop, 'ALL' is not listed", [metadata.name, types[x], containers[c].name]),
	}
}

contains(array, elem) {
	upper(array[_]) == elem
} else = false {
	true
}
