package Cx

import data.generic.common as common_lib
import data.generic.k8s as k8sLib
import future.keywords.in

CxPolicy[result] {
	some document in input.document
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	document.kind == "PodSecurityPolicy"

	not common_lib.valid_key(specInfo.spec, "allowPrivilegeEscalation")

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"issueType": "MissingAttribute",
		"searchKey": sprintf("metadata.name={{%s}}.%s", [metadata.name, specInfo.path]),
		"keyExpectedValue": "Attribute 'allowPrivilegeEscalation' should be set",
		"keyActualValue": "Attribute 'allowPrivilegeEscalation' is undefined",
	}
}

CxPolicy[result] {
	some document in input.document
	specInfo := k8sLib.getSpecInfo(document)
	metadata := document.metadata

	document.kind == "PodSecurityPolicy"

	specInfo.spec.allowPrivilegeEscalation == true

	result := {
		"documentId": document.id,
		"resourceType": document.kind,
		"resourceName": metadata.name,
		"issueType": "IncorrectValue",
		"searchKey": sprintf("metadata.name={{%s}}.%s.allowPrivilegeEscalation", [metadata.name, specInfo.path]),
		"keyExpectedValue": "Attribute 'allowPrivilegeEscalation' should be set to false",
		"keyActualValue": "Attribute 'allowPrivilegeEscalation' is true",
	}
}
