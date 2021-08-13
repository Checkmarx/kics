package Cx

import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	volumeClaimTemplates := document.spec.volumeClaimTemplates

	common_lib.valid_key(volumeClaimTemplates[j].spec.resources.requests, "storage")

	result := {
		"documentId": document.id,
		"searchKey": sprintf("metadata.name={{%s}}.spec.volumeClaimTemplates.spec.resources.requests.storage=%s", [metadata.name, volumeClaimTemplates[j].spec.resources.requests.storage]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.volumeClaimTemplates.spec.resources.requests.storage should not be set", [metadata.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.volumeClaimTemplates.spec.resources.requests.storage is set to %s", [metadata.name, volumeClaimTemplates[j].spec.resources.requests.storage]),
	}
}
