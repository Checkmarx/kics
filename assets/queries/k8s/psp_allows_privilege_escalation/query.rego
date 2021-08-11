package Cx

import data.generic.k8s as k8sLib
import data.generic.common as common_lib

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	document.kind == "PodSecurityPolicy"

	not common_lib.valid_key(specInfo.spec, "allowPrivilegeEscalation")

	result := {
		"documentId": input.document[i].id,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("metadata.name={{%s}}.%s", [metadata.name, specInfo.path]),
		"keyExpectedValue": "Attribute 'allowPrivilegeEscalation' is set",
		"keyActualValue": "Attribute 'allowPrivilegeEscalation' is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	document.kind == "PodSecurityPolicy"

	specInfo.spec.allowPrivilegeEscalation == true

	result := {
		"documentId": input.document[i].id,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name={{%s}}.%s.allowPrivilegeEscalation", [metadata.name, specInfo.path]),
		"keyExpectedValue": "Attribute 'allowPrivilegeEscalation' is false",
		"keyActualValue": "Attribute 'allowPrivilegeEscalation' is true",
	}
}
