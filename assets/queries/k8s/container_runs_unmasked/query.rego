package Cx

CxPolicy[result] {
	document := input.document[i]
	document.kind == "PodSecurityPolicy"
	spec := document.spec

	spec.allowedProcMountTypes[_] == "Unmasked"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.allowedProcMountTypes", [document.metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "AllowedProcMountTypes contains the value Default",
		"keyActualValue": "AllowedProcMountTypes contains the value Unmasked",
	}
}
