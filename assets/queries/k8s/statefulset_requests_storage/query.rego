package Cx

import data.generic.common as common_lib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	metadata := document.metadata
	volumeClaimTemplates := document.spec.volumeClaimTemplates

	common_lib.valid_key(volumeClaimTemplates[j].spec.resources.requests, "storage")

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.spec.volumeClaimTemplates.spec.resources.requests.storage=%s", [metadata.name, volumeClaimTemplates[j].spec.resources.requests.storage]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("metadata.name={{%s}}.spec.volumeClaimTemplates.spec.resources.requests.storage should not be set", [metadata.name]),
		"keyActualValue": sprintf("metadata.name={{%s}}.spec.volumeClaimTemplates.spec.resources.requests.storage is set to %s", [metadata.name, volumeClaimTemplates[j].spec.resources.requests.storage]),
	}
}
