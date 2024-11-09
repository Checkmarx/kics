package Cx

import future.keywords.in

CxPolicy[result] {
	some document in input.document
	metadata := document.metadata
	document.kind == "PodSecurityPolicy"

	document.spec.hostPID == true

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.hostPID", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'spec.hostPID' should be set to false or undefined",
		"keyActualValue": "'spec.hostPID' is true",
	}
}
