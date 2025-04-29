package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	document.kind == "PodSecurityPolicy"

	specInfo := k8sLib.getSpecInfo(document)
	common_lib.valid_key(specInfo.spec, "allowedCapabilities")

	metadata := document.metadata

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name={{%s}}.%s.allowedCapabilities", [metadata.name, specInfo.path]),
		"keyExpectedValue": "PodSecurityPolicy should not have allowed capabilities",
		"keyActualValue": "PodSecurityPolicy has allowed capabilities",
	}
}
