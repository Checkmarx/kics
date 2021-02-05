package Cx

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	volumeClaimTemplates := document.spec.volumeClaimTemplates

	object.get(volumeClaimTemplates[j].spec.resources.requests, "storage", "undefined") != "undefined"

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.volumeClaimTemplates.spec.resources.requests.storage=%s", [metadata.name, volumeClaimTemplates[j].spec.resources.requests.storage]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.volumeClaimTemplates.spec.resources.requests.storage should not be set", [metadata.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.volumeClaimTemplates.spec.resources.requests.storage is set to %s", [metadata.name, volumeClaimTemplates[j].spec.resources.requests.storage]),
	}
}
