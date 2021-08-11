package Cx

import data.generic.k8s as k8sLib
import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	document.kind == "PodSecurityPolicy"

	common_lib.valid_key(specInfo.spec, "allowedCapabilities")

	result := {
		"documentId": input.document[i].id,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name={{%s}}.%s.allowedCapabilities", [metadata.name, specInfo.path]),
		"keyExpectedValue": "PodSecurityPolicy does not have allowed capabilities",
		"keyActualValue": "PodSecurityPolicy has allowed capabilities",
	}
}
