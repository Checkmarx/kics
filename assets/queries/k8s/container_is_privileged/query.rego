package Cx

CxPolicy[result] {
	document := input.document[i]
	spec := document.spec
	types := {"initContainers", "containers"}
	containers := spec[types[x]]

	containers[c].securityContext.privileged == true

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.%s.name={{%s}}.securityContext.privileged", [metadata.name, types[x], containers[c].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.%s.name={{%s}}.securityContext.privileged is false", [types[x], containers[c].name]),
		"keyActualValue": sprintf("spec.%s.name={{%s}}.securityContext.privileged is true", [types[x], containers[c].name]),
	}
}
