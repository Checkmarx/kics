package Cx

CxPolicy[result] {
	document := input.document[i]
	object.get(document, "kind", "undefined") == "PodSecurityPolicy"
	object.get(document.spec, "hostNetwork", "undefined") == true

	metadata := document.metadata

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.hostNetwork", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'spec.hostNetwork' should be set to false or undefined",
		"keyActualValue": "'spec.hostNetwork' is true",
	}
}
