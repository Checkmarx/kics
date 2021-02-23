package Cx

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	spec := document.spec.template.spec
	types := {"initContainers", "containers"}
	containers := spec[types[x]]
	cap := containers[c].securityContext.capabilities
	not contains(cap.drop, "ALL")

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.%s.name=%s.securityContext.capabilities.drop", [metadata.name, types[x], containers[c].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.%s[%s].securityContext.capabilities.drop is not 'ALL'", [types[x], containers[c].name]),
		"keyActualValue": sprintf("spec.%s[%s].securityContext.capabilities.drop is 'ALL'", [types[x], containers[c].name]),
	}
}

contains(array, elem) {
	upper(array[_]) == elem
} else = false {
	true
}
