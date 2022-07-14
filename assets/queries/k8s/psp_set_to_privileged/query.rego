package Cx

CxPolicy[result] {
	document := input.document[i]
	document.kind == "PodSecurityPolicy"

	spec := document.spec
	spec.privileged

	metadata := document.metadata

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.privileged", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.privileged should be set to false", [metadata.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.privileged is true", [metadata.name]),
	}
}
