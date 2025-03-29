package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib

CxPolicy[result] {
	document := input.document[i]
	document.kind == "PodSecurityPolicy"

	specInfo := k8sLib.getSpecInfo(document)
	not common_lib.valid_key(specInfo.spec, "allowPrivilegeEscalation")

	metadata := document.metadata

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("metadata.name={{%s}}.%s", [metadata.name, specInfo.path]),
		"keyExpectedValue": "Attribute 'allowPrivilegeEscalation' should be set",
		"keyActualValue": "Attribute 'allowPrivilegeEscalation' is undefined",
	}
}

CxPolicy[result] {
	document := input.document[i]
	document.kind == "PodSecurityPolicy"

	specInfo := k8sLib.getSpecInfo(document)
	specInfo.spec.allowPrivilegeEscalation == true

	metadata := document.metadata

	result := {
		"documentId": input.document[i].id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name={{%s}}.%s.allowPrivilegeEscalation", [metadata.name, specInfo.path]),
		"keyExpectedValue": "Attribute 'allowPrivilegeEscalation' should be set to false",
		"keyActualValue": "Attribute 'allowPrivilegeEscalation' is true",
	}
}
