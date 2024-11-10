package Cx

import future.keywords.in

CxPolicy[result] {
	some document in input.document
	document.kind == "PodSecurityPolicy"
	spec := document.spec

	"Unmasked" in spec.allowedProcMountTypes

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
