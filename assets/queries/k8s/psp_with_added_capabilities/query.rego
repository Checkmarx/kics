package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	document.kind == "PodSecurityPolicy"

	object.get(specInfo.spec, "allowedCapabilities", "undefined") != "undefined"

	result := {
		"documentId": input.document[i].id,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name={{%s}}.%s.allowedCapabilities", [metadata.name, specInfo.path]),
		"keyExpectedValue": "PodSecurityPolicy does not have allowed capabilities",
		"keyActualValue": "PodSecurityPolicy has allowed capabilities",
	}
}
