package Cx

CxPolicy[result] {
	document := input.document[i]
	document.kind == "PodSecurityPolicy"
	document.spec.hostPID == true

	metadata := document.metadata

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.hostPID", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'spec.hostPID' should be set to false or undefined",
		"keyActualValue": "'spec.hostPID' is true",
	}
}
