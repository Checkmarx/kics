package Cx

CxPolicy[result] {
	metadata := input.document[i].metadata
	spec := input.document[i].spec
	spec.privileged

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name=%s.spec.privileged", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name=%s.spec.privileged is false", [metadata.name]),
		"keyActualValue": sprintf("metadata.name=%s.spec.privileged is true", [metadata.name]),
	}
}
