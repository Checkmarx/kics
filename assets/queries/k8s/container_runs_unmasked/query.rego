package Cx

CxPolicy[result] {
	document := input.document[i]
	document.kind == "PodSecurityPolicy"
	spec := document.spec

	spec.allowedProcMountTypes[_] == "Unmasked"

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": document.metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.allowedProcMountTypes", [document.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "AllowedProcMountTypes should contain the value Default",
		"keyActualValue": "AllowedProcMountTypes contains the value Unmasked",
	}
}
