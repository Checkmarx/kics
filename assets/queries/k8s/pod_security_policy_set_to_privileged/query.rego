package Cx

CxPolicy[result] {
	document := input.document[i]
	spec := document.spec
	spec.privileged

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.privileged", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.privileged is false", [metadata.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.privileged is true", [metadata.name]),
	}
}
