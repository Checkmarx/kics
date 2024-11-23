package Cx

import future.keywords.in

CxPolicy[result] {
	some document in input.document
	metadata := document.metadata
	object.get(document, "kind", "undefined") == "PodSecurityPolicy"

	object.get(document.spec, "hostNetwork", "undefined") == true

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.hostNetwork", [metadata.name]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "'spec.hostNetwork' should be set to false or undefined",
		"keyActualValue": "'spec.hostNetwork' is true",
	}
}
