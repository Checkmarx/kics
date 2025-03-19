package Cx

CxPolicy[result] {
	document := input.document[i]
	document.kind == "PodSecurityPolicy"
	document.spec.hostIPC == true

	metadata := document.metadata

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.hostIPC", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'spec.hostIPC' should be set to false or undefined",
		"keyActualValue": "'spec.hostIPC' is true",
	}
}
