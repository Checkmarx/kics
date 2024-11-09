package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	document.kind == "PodSecurityPolicy"

	common_lib.valid_key(specInfo.spec, "allowedCapabilities")

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name={{%s}}.%s.allowedCapabilities", [metadata.name, specInfo.path]),
		"keyExpectedValue": "PodSecurityPolicy should not have allowed capabilities",
		"keyActualValue": "PodSecurityPolicy has allowed capabilities",
	}
}
