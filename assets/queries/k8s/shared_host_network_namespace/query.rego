package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	specInfo := k8sLib.getSpecInfo(document)

	specInfo.spec.hostNetwork == true

	result := {
		"documentId": input.document[i].id,
		"searchKey": sprintf("metadata.name={{%s}}.%s.hostNetwork", [metadata.name, specInfo.path]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.hostNetwork' is false or undefined", [specInfo.path]),
		"keyActualValue": sprintf("'%s.hostNetwork' is true", [specInfo.path]),
	}
}
