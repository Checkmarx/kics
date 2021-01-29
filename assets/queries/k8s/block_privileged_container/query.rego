package Cx

CxPolicy[result] {
	metadata := input.document[i].metadata
	spec := input.document[i].spec
	types := {"initContainers", "containers"}
	containers := spec[types[x]]
	containers[c].securityContext.privileged == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.%s.name=%s.securityContext.privileged", [metadata.name, types[x], containers[c].name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("spec.%s.name=%s.securityContext.privileged is false", [types[x], metadata.name, containers[c].name]),
		"keyActualValue": sprintf("spec.%s.name=%s.securityContext.privileged is true", [types[x], metadata.name, containers[c].name]),
	}
}
