package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	metadata := document.metadata
	specInfo := k8sLib.getSpecInfo(document)

	specInfo.spec.hostIPC == true

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"searchKey": sprintf("metadata.name={{%s}}.%s.hostIPC", [metadata.name, specInfo.path]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": sprintf("'%s.hostIPC' should be set to false or undefined", [specInfo.path]),
		"keyActualValue": sprintf("'%s.hostIPC' is true", [specInfo.path]),
	}
}
