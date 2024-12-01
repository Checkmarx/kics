package Cx

import data.generic.k8s as k8sLib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	metadata := document.metadata
	specInfo := k8sLib.getSpecInfo(document)

	specInfo.spec.hostNetwork == true

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.hostNetwork", [metadata.name, specInfo.path]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.hostNetwork' should be set to false or undefined", [specInfo.path]),
		"keyActualValue": sprintf("'%s.hostNetwork' is true", [specInfo.path]),
	}
}
