package Cx

import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	document.kind == "PodSecurityPolicy"

	object.get(document.spec, "allowPrivilegeEscalation", "undefined") == "undefined"

	result := {
		"documentId": input.document[i].id,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("metadata.name=%s.%s", [metadata.name, specInfo.path]),
		"keyExpectedValue": "Attribute 'allowPrivilegeEscalation' is set",
		"keyActualValue": "Attribute 'allowPrivilegeEscalation' is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	document.kind == "PodSecurityPolicy"

	document.spec.allowPrivilegeEscalation == true

	result := {
		"documentId": input.document[i].id,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name=%s.%s.allowPrivilegeEscalation", [metadata.name, specInfo.path]),
		"keyExpectedValue": "Attribute 'allowPrivilegeEscalation' is false",
		"keyActualValue": "Attribute 'allowPrivilegeEscalation' is true",
	}
}
